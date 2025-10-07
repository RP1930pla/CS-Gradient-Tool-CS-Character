import QtQuick 2.15
import Painter 1.0

import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.2
import QtQuick.Dialogs
import AlgWidgets 2.0
import AlgWidgets.Style 2.0

        Item{
        id: genericWindow
        width: 512
        // minimumWidth : 400
        height: 200
        objectName: "Gradient Editor"

        //ORGANIZE EVERYTHING IN A COLUMN LAYOUT
        ColumnLayout{
            spacing : 6

            //FIRST GRADIENT (EDITABLE)
            Rectangle{
                height: 30
                width: 512
                id: base
                gradient: Gradient{
                    id: dynamicGradient
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "black"}
                    GradientStop { position: 1.0; color: "white"}
                }
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        propagateComposedEvents: true

                        onPressed: {
                            var minDist = parent.width;
                            for(var i = 0; i < pickRoot.children.length; i++)
                            {
                                var pb = pickRoot.children[i];
                                var dist = Math.abs(mouse.x - pb.x);
                                if(dist < minDist)
                                {
                                    minDist = dist;
                                }
                            }

                            if(minDist > 15)
                            {
                                var button = pickButton.createObject(pickRoot);
                                button.width = 15;
                                button.height = 15;
                                button.x = mouse.x;
                                button.y = 0;
                                updateStops();
                            }
                        }

                    }
            }

            AlgLabel{
                text : "Reference Color Picker Gradient"
                font.bold : true
                antialiasing : true
            }

            //SECOND GRADIENT (FIXED)
            Rectangle{
                width: 512 
                height: 30
                id: saverect
                gradient: Gradient{
                    id: fixedGradient
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "black"}
                    GradientStop { position: 1.0; color: "white"}
                }

            }

            AlgLabel{
                text : "Saving Options"
                font.pixelSize : 12
                font.bold : true
                font.underline : true
                antialiasing : true
            }

            AlgLabel{
                text : "Gradient Name:"
                font.italic : true
                antialiasing : true

                Component.onCompleted:{
                    projectReloadGradient();
                }
            }

            AlgTextInput{
                id: saveName
                Layout.preferredWidth : 200
                text: "gradient"
                tooltip : "Gradient Name"
            }

            RowLayout{
                //SAVE BUTTON
                AlgButton{
                    text: "Save gradient"
                    onClicked:{
                        saveGradient()
                        // importAsset()
                    }
                }

                AlgButton{
                    text: "Change Export Folder"
                    onClicked:{
                        folderDialog.open()
                    }
                }

                AlgLabel{
                    id: folderLabel
                    text: alg.settings.value("GradientFolder").toString();
                }

            }

            RowLayout{
                AlgButton{
                    text: "Save JSON"
                    onClicked:{
                        saveAsJSON();
                    }
                }

                AlgButton{
                    text: "Load JSON"
                    onClicked:{
                        // jsonDialog.folder = alg.settings.value("GradientFolder");
                        jsonDialog.open()
                    }
                }

                AlgButton{
                    text: "Load last saved on project"
                    onClicked:{
                        projectReloadGradient();
                    }
                }
            }


            AlgColorPicker
            {
                id: colorPicker
            }

            FolderDialog{
                id: folderDialog
                title: qsTr("Please choose a folder")
                selectedFolder: alg.settings.value("GradientFolder")
                onAccepted:
                {
                    setSettingsFolderPath();
                    folderDialog.close()
                }

                onRejected:
                {
                    folderDialog.close()
                    alg.log.info(alg.settings.value("GradientFolder"));
                }
            }

            FileDialog{
                id: jsonDialog
                title: qsTr("Please select a JSON Preset file")
                nameFilters: [ "JSON (*.json)", "All files (*)" ]
                onAccepted:
                {
                    loadJSON();
                    jsonDialog.close();
                }

                onRejected:
                {
                    jsonDialog.close();
                }
            }

        }

        //ITEM SO WE CAN PARENT BUTTONS REPRESENTING STOPS OF THE GRADIENT
        Item{
            id: pickRoot
            width: base.width
            height: base.height
            onChildrenChanged:
            {
                updateStops();
            }
        }

        //COLOR PICKER BUTTON COMPONENT
        Component 
        {
            id: pickButton;
            
            Rectangle {
                id: pickRect
                width: 15; height: 15
                color: colorPicker.color
                border.color: "grey"
                MouseArea {
                    anchors.fill: parent
                    drag.target: pickRect
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0
                    drag.maximumX: pickRoot.width - pickRect.width

                    onDoubleClicked:
                    {
                        if (mouse.modifiers & Qt.ControlModifier)
                        {
                            pickRect.destroy();
                        }
                        else
                        {
                            var px = pickRect.x;
                            var py = pickRect.y;
                            colorPicker.show(mapToGlobal(0,-100));
                        }
                    }
                    onReleased:
                    {
                        updateStops();
                    }
                    AlgColorPicker
                    {
                        id: colorPicker
                        onColorSelected:
                        {
                            pickRect.color = color;
                            updateStops();
                        }
                    }
                }
            }  
        }

        //GRADIENT STOPS COMPONENT BASE
        Component
        {
            id: stopComponent
            GradientStop {}
        }

        Timer{
            id : timer
            onTriggered:{
                importAsset()
            }
        }

        function delayImport(delayTime)
        {
            timer.interval = delayTime;
            timer.repeat = false;
            // timer.triggered.connect(cb);
            timer.start();
        }

        function updateStops()
        {
            var updatedStops = [];
            for(var i = 0; i < pickRoot.children.length; i++)
            {
                var pb = pickRoot.children[i];
                var stop = stopComponent.createObject(dynamicGradient, {"position": pb.x / pickRoot.width, "color": pb.color});
                updatedStops.push(stop);
            }

            dynamicGradient.stops = updatedStops;
            base.update();

            saveToProjectSettings();
        }

        function saveGradient()
        {
            var folderString = alg.settings.value("GradientFolder").toString();
            folderString = folderString.replace("file:///","");

            base.grabToImage(function(result) {
            result.saveToFile(folderString + "/" + saveName.text + ".png")
            }, Qt.size(512,32))


            alg.log.info(folderString + "/" + saveName.text + ".png")
            delayImport(500)

        }

        function importAsset()
        {
            try {
            var folderString =  alg.settings.value("GradientFolder").toString();
            folderString = folderString.replace("file:///","");

            alg.resources.importProjectResource(folderString + "/" + saveName.text + ".png", "texture")
            } catch(err) {
            alg.log.error("ERROR: "+err.message)
            }

            
        }

        function setSettingsFolderPath()
        {
            if(alg.settings.contains("GradientFolder"))
            {
                // alg.log.info(alg.settings.value("GradientFolder"));
                alg.settings.setValue("GradientFolder",folderDialog.selectedFolder);
                folderDialog.selectedFolder = alg.settings.value("GradientFolder");
            }
            else
            {
                // alg.log.info(alg.settings.value("GradientFolder"));
                alg.settings.setValue("GradientFolder",folderDialog.folder);
            }

            folderLabel.text = alg.settings.value("GradientFolder");
            folderLabel.forceLayout();
        }

        function saveAsJSON()
        {
            var folderString = alg.settings.value("GradientFolder").toString();
            folderString = folderString.replace("file:///","");

            var fileName = folderString + "/" + saveName.text + ".json";
            var jsonFile = alg.fileIO.open(fileName, "w");
            // jsonFile.newFile();

            var positionArray = [];
            var colorArray = [];

            for(var i = 0; i< pickRoot.children.length; i++)
            {
                var pb = pickRoot.children[i];
                positionArray[i] = pb.x / pickRoot.width;
                colorArray[i] = {r: pb.color.r, g: pb.color.g, b: pb.color.b, a: pb.color.a};

            }

            //JAVASCRIPT OBJECT
            var gradientObject = {positions: positionArray, color: colorArray};
            var jsonSTRING = JSON.stringify(gradientObject);
            jsonFile.write(jsonSTRING);
            jsonFile.close();

        }

        function loadJSON()
        {
            var folderString = jsonDialog.selectedFile.toString();
            folderString = folderString.replace("file:///","");
            var fileName = folderString;

            var jsonFile = alg.fileIO.open(fileName, "r");
            var jsonString = jsonFile.readAll();

            alg.log.info(fileName);

            var jsonObject = JSON.parse(jsonString);

            //DELETE ALL BUTTONS
            for(var i = 0; i<pickRoot.children.length; i++)
            {
                pickRoot.children[i].destroy();
            }

            for(var i = 0; i<jsonObject.positions.length; i++)
            {
                var button = pickButton.createObject(pickRoot);
                button.width = 15;
                button.height = 15;
                button.y = 0;
                button.x = jsonObject.positions[i] * pickRoot.width;
                button.color = Qt.rgba(jsonObject.color[i].r,jsonObject.color[i].g,jsonObject.color[i].b,jsonObject.color[i].a);
                // alg.log.info(jsonObject.positions[i]);
                // alg.log.info("color: " + jsonObject.color[i].r);
            }
            jsonFile.close();
            updateStops();
        }

        function saveToProjectSettings()
        {
            var positionArray = [];
            var colorArray = [];

            for(var i = 0; i< pickRoot.children.length; i++)
            {
                var pb = pickRoot.children[i];
                positionArray[i] = pb.x / pickRoot.width;
                colorArray[i] = {r: pb.color.r, g: pb.color.g, b: pb.color.b, a: pb.color.a};

            }

            //JAVASCRIPT OBJECT
            var gradientObject = {positions: positionArray, color: colorArray};
            alg.project.settings.setValue("GradientData", gradientObject);
        }

        function projectReloadGradient()
        {
            var jsonObject =  alg.project.settings.value("GradientData");
            for(var i = 0; i<pickRoot.children.length; i++)
            {
                pickRoot.children[i].destroy();
            }
            if(alg.project.settings.contains("GradientData"))
            {
                for(var i = 0; i<jsonObject.positions.length; i++)
                {
                    var button = pickButton.createObject(pickRoot);
                    button.width = 15;
                    button.height = 15;
                    button.y = 0;
                    button.x = jsonObject.positions[i] * pickRoot.width;
                    button.color = Qt.rgba(jsonObject.color[i].r,jsonObject.color[i].g,jsonObject.color[i].b,jsonObject.color[i].a);
                    // alg.log.info(jsonObject.positions[i]);
                    // alg.log.info("color: " + jsonObject.color[i].r);
                }
            }

            updateStops();
        }


    }
