import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1

Item {
    U1db.Database {
        id: storage
        path: "CNotesDatabase"
    }

    U1db.Document {
        id: notesDatabase
        docId: 'notes'
        database: storage
        create: true
        defaults: {
            notes: [{}]
        }
    }

    function setNote(id, title, body, tag, category, archive, view) {
//        var values = "import QtQuick 2.0; import U1db 1.0 as U1db; U1db.Document {id:"+id+";title:"+title+";docId:"+id+";create: true;defaults: {id:'';docId:'';title:'';body:'';tag:'';category:'';archive:'';view:''}}"
        var values = "import QtQuick 2.0; import U1db 1.0 as U1db; U1db.Document {id:"+id+";database: cNotesDb;docId: "+id+";title:"+title+";create: true;}"
        Qt.createQmlObject(values, cNotesDb);
//        var values = {title: title}
//        values = doc
//        print(values.contents['title'])
    }

    function getTitle(id) {
        var tempValues = {};
        tempValues = contents.title
    }
}
