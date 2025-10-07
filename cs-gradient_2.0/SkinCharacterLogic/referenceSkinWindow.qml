import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.3

import AlgWidgets 2.0
import AlgWidgets.Style 2.0


Item
{
    id: skinWindow
    width: 512
    height: 200
    objectName: "Persona - Skin Ref"

    ColumnLayout
    {
        spacing : 6

        //EYE MASK------------------------
        AlgLabel
        {
            text: "Eye Mask Values:"
            font.bold : true
            font.underline : true
            font.pixelSize : 15
            antialiasing : true
        }

        RowLayout
        {
            AlgLabel
            {
                text: "Iris Value:"
                font.bold : true
                antialiasing : true
            }
            Rectangle
            {
                height: 30
                width: 60
                color: "white"
            }

            RowLayout
            {
                AlgLabel
                {
                    text: "Pupil Value:"
                    font.bold : true
                    antialiasing : true
                }
                Rectangle
                {
                    height: 30
                    width: 60
                    color: "#808080"
                }
            }
        }
        //---------------------------------

        //MOUTH MASK-----------------------
        AlgLabel
        {
            text: "Mouth Mask Values:"
            font.bold : true
            font.underline : true
            font.pixelSize : 15
            antialiasing : true
        }

        RowLayout
        {
            AlgLabel
            {
                text: "Mouth Value:"
                font.bold : true
                antialiasing : true
            }
            Rectangle
            {
                height: 30
                width: 60
                color: "white"
            }

            RowLayout
            {
                AlgLabel
                {
                    text: "Teeth Value:"
                    font.bold : true
                    antialiasing : true
                }
                Rectangle
                {
                    height: 30
                    width: 60
                    color: "#808080"
                }
            }
        }


    }


}