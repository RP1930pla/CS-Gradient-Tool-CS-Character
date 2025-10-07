import QtQuick 2.7 
import Painter 1.0

import QtQuick.Layouts 1.2
import QtQuick.Dialogs
import QtQuick.Controls 2.0
import AlgWidgets 2.0
import AlgWidgets.Style 2.0


PainterPlugin
{
    tickIntervalMS: -1 // Disabled Tick 
    jsonServerPort: -1 // Disabled JSON server 


    Component.onCompleted: 
    { 
        // Create a toolbar button 
        var OpenButton = alg.ui.addToolBarWidget("openWindow.qml");
        var InterfaceButton = alg.ui.addToolBarWidget("toolbar.qml"); 
        // var PersonaWindowButton = alg.ui.addToolBarWidget("SkinCharacterLogic/openSkinWindow.qml");
        var NPCWindowButton = alg.ui.addToolBarWidget("SkinCharacterLogic/NPC_Channels.qml");
        // Connect the function to the button 
        if(InterfaceButton) 
        { 
            InterfaceButton.clicked.connect(createChannels); 
        }

        if(OpenButton)
        {
            // OpenButton.clicked.connect(openWindow);
            alg.ui.addDockWidget("GradientLogic.qml");
        }

        // if(PersonaWindowButton)
        // {
        //     alg.ui.addDockWidget("SkinCharacterLogic/referenceSkinWindow.qml");
        // }

        if(NPCWindowButton)
        {
            NPCWindowButton.clicked.connect(createNPCChannels);
        }

    }
    
    onProjectOpened: {
                // Called when the project is fully loaded
                // alg.log.info("onProjectOpened")
                // gradientDock.projectReloadGradient();
    }

    function createChannels()
    {
        try
        {
            if(!alg.project.isOpen())
            {
                return;
            }

            var MaterialPath = alg.texturesets.getActiveTextureSet();
            var TextureSetName = MaterialPath[0];
            // var matNameArray = TextureSetName.split("_");
            // var folderName = matNameArray[0];
            alg.log.info(TextureSetName);
            alg.texturesets.addChannel(TextureSetName,"user0", "L8");
            alg.texturesets.addChannel(TextureSetName,"user1", "L8");
            alg.texturesets.addChannel(TextureSetName,"user2", "L8");
            alg.texturesets.addChannel(TextureSetName, "user3", "L8");

            alg.texturesets.addChannel(TextureSetName, "user4", "L8");
            alg.texturesets.addChannel(TextureSetName, "user5", "L8");
            alg.texturesets.addChannel(TextureSetName, "user6", "L8");
            alg.texturesets.addChannel(TextureSetName, "user7", "L8");

            alg.texturesets.editChannel(TextureSetName,"user0", "L8", "Outline");
            alg.texturesets.editChannel(TextureSetName,"user1", "L8", "SoftLight");
            alg.texturesets.editChannel(TextureSetName,"user2", "L8", "Eye");
            alg.texturesets.editChannel(TextureSetName,"user3", "L8", "Mouth");

            alg.texturesets.editChannel(TextureSetName,"user4", "L8", "Skin");
            alg.texturesets.editChannel(TextureSetName,"user5", "L8", "Dark Shadow");
            alg.texturesets.editChannel(TextureSetName,"user6", "L8", "Light Shadow");
            alg.texturesets.editChannel(TextureSetName,"user7", "L8", "Lips");

            
            alg.log.info("Created all channels needed");
        }
        catch(error)
        {
            alg.log.exception(error);
        }
    }

    function createNPCChannels()
    {
                try
        {
            if(!alg.project.isOpen())
            {
                return;
            }

            var MaterialPath = alg.texturesets.getActiveTextureSet();
            var TextureSetName = MaterialPath[0];
            // var matNameArray = TextureSetName.split("_");
            // var folderName = matNameArray[0];
            alg.log.info(TextureSetName);
            alg.texturesets.addChannel(TextureSetName,"user0", "L8");
            alg.texturesets.addChannel(TextureSetName,"user1", "L8");


            alg.texturesets.editChannel(TextureSetName,"user0", "L8", "Outline");
            alg.texturesets.editChannel(TextureSetName,"user1", "L8", "SoftLight");
            
            alg.log.info("Created all channels needed");
        }
        catch(error)
        {
            alg.log.exception(error);
        }
    }

    function openWindow()
    {
        try
        {
            if(!alg.project.isOpen())
            {
                return;
            }
            // genericWindow.open()
        }
        catch(error)
        {
            alg.log.exception(error)
        }
    }

}

