import QtQuick 2.0
import U1db 1.0 as U1db
import Ubuntu.Components 0.1

Item {
    U1db.Database {
        id: cNotesDb
        path: "CNotesDatabase"
    }

    function setNote(id, title, body, tag, category, archive, view) {
        var values = "import QtQuick 2.0; import U1db 1.0 as U1db; U1db.Document {id:"+id+";title:"+title+";docId:"+id+";body:"+body+";tag:"+tag+";category:"+category+";archive:"+archive+";view:"+view+";create: true;defaults: {id:'';docId:'';title:'';body:'';tag:'';category:'';archive:'';view:''}}"
        Qt.createQmlObject(values, cNotesDb);
    }

    function getTitle(id) {
        var tempValues = {};
        tempValues = contents.title
        print (tempValues)
    }
}
