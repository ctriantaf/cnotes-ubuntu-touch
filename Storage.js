//Storage.js
// First, let's create a short helper function to get the database connection

function getDatabase() {
     return LocalStorage.openDatabaseSync("CNotes", "1.0", "CNotesDB", 100000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the notes table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS notes(id TEXT NOT NULL, title TEXT NOT NULL, body TEXT NOT NULL,'
                         + 'category TEXT NOT NULL, tag TEXT NOT NULL, archive TEXT NOT NULL, view TEXT NOT NULL)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS categories(name TEXT NOT NULL)');
      });
}

function deleteDatabase() {
    var db = getDatabase();
    db.transaction(
        function(tx){
            tx.executeSql("DROP TABLE notes;");
            tx.executeSql("DROP TABLE categories")
//            tx.executeSql("DROP DATABASE CNotesDB;");
        }
    );
}

// This function is used to write a setting into the database
function setNote(id, title, body, category, tag, archive, view) {
   var db = getDatabase();
   var res = "";
   db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO notes VALUES (?,?,?,?,?,?,?);', [id,title,body,category,tag,archive,view]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
  );
  // The function returns “OK” if it was successful, or “Error” if it wasn't
  return res;
}

function removeNote(id) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM notes WHERE id=?;', [id]);
              //console.log(rs.rowsAffected)
              if (rs.rowsAffected > 0) {
                res = "OK";
              } else {
                res = "Error";
              }
        }
    );
  return res;
}

function fetchAllNotesWithTag(t) {
    var db = getDatabase();
    var res= new Array();
    db.transaction(function(tx) {
    var rs = tx.executeSql('SELECT * FROM notes;');
        var k = 0
        for (var i = 0; i < rs.rows.length; i++) {
            if (containTag(rs.rows.item(i).tag.split(','), t)) {
                res[k] = rs.rows.item(i).id
                k++
            }
        }
    })
    return res
}

function containTag(tagsArray, t) {
    //This function is a bit different from CNotes.qml containTag function
    for (var i = 0; i < tagsArray.length; i++) {
        if (tagsArray[i] === t)
            return true
        return false
    }
}

function fetchAllNotesWithCategory(c) {
    var db = getDatabase();
    var res= new Array();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT id FROM notes WHERE category=?;', [c]);
        var k = 0;
        for (var i = 0; i < rs.rows.length; i++) {
            res[k] = rs.rows.item(i).id
            k++
        }
    })
    return res
}

function fetchNotes(archive) {
    var db = getDatabase();
    var res = new Array();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM notes WHERE archive=?;', [archive]);
        for (var i = 0; i < rs.rows.length; i++) {
            res[i] = rs.rows.item(i).id
        }
    })
    return res
}

function getCount() {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
    var rs = tx.executeSql('SELECT * FROM notes;');
        res = rs.rows.length
    })
    return res;
}


function getTitle(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT title FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).title;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function getBody(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT body FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).body;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function getCategory(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT category FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).category;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function getTags(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT tag FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).tag;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function getArchive(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT archive FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).archive;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function getView(id) {
    var db = getDatabase();
    var res="";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT view FROM notes WHERE id=?;', [id]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).view;
        } else {
            res = "Unknown";
        }
    })
    return res
}

function fetchAllCategories() {
    var db = getDatabase();
    var res= new Array();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM categories;');
        for (var i = 0; i < rs.rows.length; i++) {
            res[i] = rs.rows.item(i).name
        }
    })
    return res
}
function addCategory(name) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
         var rs = tx.executeSql('INSERT OR REPLACE INTO categories VALUES (?);', [name]);
               //console.log(rs.rowsAffected)
               if (rs.rowsAffected > 0) {
                 res = "OK";
               } else {
                 res = "Error";
               }
         }
   );
   // The function returns “OK” if it was successful, or “Error” if it wasn't
   return res;
}

// Replace category!

function removeCategory(name) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM categories WHERE name=?;', [name]);
        //console.log(rs.rowsAffected)
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
      );
    return res;
}
