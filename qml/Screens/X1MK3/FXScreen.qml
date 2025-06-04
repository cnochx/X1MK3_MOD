import CSI 1.0
import QtQuick 2.0

import "../../CSI/X1MK3/Defines"
import "Scripts/DisplayHelpers.js" as DisplayHelpers

Item {
  id: screen

  property int side: ScreenSide.Left;

  property string settingsPath: ""
  property string propertiesPath: ""

  width:  128
  height: 64
  clip:   true

  readonly property variant fxText: ["FX 1", "FX 2", "FX 3", "FX 4"]
  readonly property variant setupTextA: [fxText[primaryFxUnitProp.value - 1], buttonText1a[leftSide], buttonText2a[leftSide], buttonText3a[leftSide], buttonText4a[leftSide], buttonText5a[leftSide], buttonText6a[leftSide], buttonText7a[leftSide], buttonText8a[leftSide]]
  readonly property variant setupTextB: [fxText[primaryFxUnitProp.value - 1], buttonText1b[leftSide], buttonText2b[leftSide], buttonText3b[leftSide], buttonText4b[leftSide], buttonText5b[leftSide], buttonText6b[leftSide], buttonText7b[leftSide], buttonText8b[leftSide]]
  // readonly property variant buttonText1a: ["Mode Tap", "Browser"]
  // readonly property variant buttonText1b: ["Deck Sw.", "Mode"]
  // readonly property variant buttonText2a: ["XONE:92", "FX Assign"]
  // readonly property variant buttonText2b: ["Mid Low", "Unit Foc."]
  // readonly property variant buttonText3a: ["Volume", "FX Units"]
  // readonly property variant buttonText3b: ["Shifted", "Linked"]
  // readonly property variant buttonText4a: ["Single", "Overmap"]
  // readonly property variant buttonText4b: ["Monitor", "Modifier"]
  // readonly property variant buttonText5a: ["", "Maximize"]
  // readonly property variant buttonText5b: ["", "Browser"]
  // readonly property variant buttonText6a: ["Low EQ", ""]
  // readonly property variant buttonText6b: ["Shifted", ""]
  // readonly property variant buttonText7a: ["", "Sec.FX"]
  // readonly property variant buttonText7b: ["", "Blocked"]
  // readonly property variant buttonText8a: ["Mixer", ""]
  // readonly property variant buttonText8b: ["Blocked", ""]
  readonly property variant buttonText1a: ["Mode Tap", "Beat"]
  readonly property variant buttonText1b: ["Deck Sw.", "Counter"]
  readonly property variant buttonText2a: ["Browser", "Phrase L."]
  readonly property variant buttonText2b: ["Mode", " " + phraseLength + " Bar"]
  readonly property variant buttonText3a: ["Maximize", ""]
  readonly property variant buttonText3b: ["Browser", ""]
  readonly property variant buttonText4a: ["Load Min.", "Overmap"]
  readonly property variant buttonText4b: ["Browser", "Modifier"]
  readonly property variant buttonText5a: ["XONE:92", "Mixer"]
  readonly property variant buttonText5b: ["Mid Low", "Blocked"]
  readonly property variant buttonText6a: ["Low EQ", "FX Assign"]
  readonly property variant buttonText6b: ["Shifted", "Unit Foc."]
  readonly property variant buttonText7a: ["Volume", "FX Units"]
  readonly property variant buttonText7b: ["Shifted", "Linked"]
  readonly property variant buttonText8a: ["Single", "Sec.FX"]
  readonly property variant buttonText8b: ["Monitor", "Blocked"]
  property int leftSide: propertiesPath == "mapping.state.left.fx" ? 0 : 1;
  
  MappingProperty { id: customBeatCounterPhraseLengthProp; path: "mapping.settings.custom_phrase_length" }
  property string phraseLength: Math.pow (2, customBeatCounterPhraseLengthProp.value)

  MappingProperty { id: deviceSetupStateProp; path: "mapping.state.device_setup_state" }
  property alias deviceSetupState: deviceSetupStateProp.value

  MappingProperty { id: fxSectionLayerProp; path: "mapping.state.fx_section_layer"; onValueChanged: onLayerChanged() }
  property alias fxSectionLayer: fxSectionLayerProp.value

  MappingProperty { id: primaryFxUnitProp; path: screen.propertiesPath + ".primary_fx_unit" }
  MappingProperty { id: secondaryFxUnitProp; path: screen.propertiesPath + ".secondary_fx_unit" }
  readonly property int fxUnitIdx: (fxSectionLayer === FXSectionLayer.fx_primary ? primaryFxUnitProp.value : secondaryFxUnitProp.value)

  MappingProperty { id: deckIdxProp; path: screen.propertiesPath + ".active_deck" }
  property alias deckIdx: deckIdxProp.value

  MappingProperty { id: knobsAreActiveProp; path: screen.propertiesPath + ".knobs_are_active" }
  property alias knobsAreActive: knobsAreActiveProp.value

  MappingProperty { id: lastTouchedKnobProp; path: screen.propertiesPath + ".last_active_knob" }
  property alias lastTouchedKnob: lastTouchedKnobProp.value

  MappingProperty { id: softTakeoverDirectionProp; path: screen.propertiesPath + ".softtakeover." + lastTouchedKnob + ".direction" }
  property alias softTakeoverDirection: softTakeoverDirectionProp.value

  MappingProperty { id: shiftProp; path: "mapping.state.shift" }
  property alias shift: shiftProp.value

  // MappingProperty { id: browseShiftPushActionProp; path: "mapping.settings.browse_shiftpush_action" }
  // property alias browseShiftPushAction: browseShiftPushActionProp.value
  MappingProperty { id: customMixerVolumeOnShiftProp; path: "mapping.settings.custom_mixer_volume_on_shift" }
  property alias customMixerVolumeOnShift: customMixerVolumeOnShiftProp.value

  MappingProperty { id: customMixerMidLowProp; path: "mapping.settings.custom_mixer_mid_low" }
  property alias customMixerMidLow: customMixerMidLowProp.value
  MappingProperty { id: customMixerLowOnShiftProp; path: "mapping.settings.custom_mixer_low_on_shift" }
  property alias customMixerLowOnShift: customMixerLowOnShiftProp.value

  MappingProperty { id: lastTouchedButtonProp; path: screen.propertiesPath + ".last_active_button" }
  property alias lastTouchedButton: lastTouchedButtonProp.value

  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + deckIdx + ".type" }
  
  MappingProperty { id: mixerStemOverlayProp; path: screen.propertiesPath + ".mixer_stem_overlay_active" }
  property bool isStemOverlayActive: (deckTypeProp.value == DeckType.Stem) && mixerStemOverlayProp.value && fxSectionLayer === FXSectionLayer.mixer
  property bool isRemixOverlayActive: (deckTypeProp.value == DeckType.Remix) && mixerStemOverlayProp.value && fxSectionLayer === FXSectionLayer.mixer

  // Effect unit properties
  AppProperty { id: fxUnitType; path: "app.traktor.fx." + fxUnitIdx + ".type"; onValueChanged: onFxChanged() }
  AppProperty { id: fxSelect1; path: "app.traktor.fx." + fxUnitIdx + ".select.1"; onValueChanged: onFxChanged() }
  AppProperty { id: fxSelect2; path: "app.traktor.fx." + fxUnitIdx + ".select.2" }
  AppProperty { id: fxSelect3; path: "app.traktor.fx." + fxUnitIdx + ".select.3" }
  AppProperty { id: fxDryWet; path: "app.traktor.fx." + fxUnitIdx + ".dry_wet" }
  AppProperty { id: fxParameterName1; path: "app.traktor.fx." + fxUnitIdx + ".knobs.1.name" }
  AppProperty { id: fxParameterName2; path: "app.traktor.fx." + fxUnitIdx + ".knobs.2.name" }
  AppProperty { id: fxParameterName3; path: "app.traktor.fx." + fxUnitIdx + ".knobs.3.name" }
  AppProperty { id: fxParameterValue1; path: "app.traktor.fx." + fxUnitIdx + ".parameters.1" }
  AppProperty { id: fxParameterValue2; path: "app.traktor.fx." + fxUnitIdx + ".parameters.2" }
  AppProperty { id: fxParameterValue3; path: "app.traktor.fx." + fxUnitIdx + ".parameters.3" }

  // Pattern Player properties
  AppProperty { id: currentKit;   path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.kit_shortname" }
  AppProperty { id: currentStep;  path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.current_step" }
  AppProperty { id: currentSound; path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.current_sound" }

  // Mixer Mode properties
  AppProperty { id: deckCue; path: "app.traktor.mixer.channels." + deckIdx + ".cue"  }
  AppProperty { id: deckVolume; path: "app.traktor.mixer.channels." + deckIdx + ".volume"  }
  AppProperty { id: deckEqHigh; path: "app.traktor.mixer.channels." + deckIdx + ".eq.high" }
  AppProperty { id: deckEqMid;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.mid"  }
  AppProperty { id: deckEqMidLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.mid_low"  }
  AppProperty { id: deckEqLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.low"  }
  AppProperty { id: deckGain;  path: "app.traktor.mixer.channels." + deckIdx + ".gain"  }
  AppProperty { id: deckKillHigh;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.kill_high"; onValueChanged: (lastTouchedKnob = 1) }
  AppProperty { id: deckKillMid;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.kill_mid"; onValueChanged: (lastTouchedKnob = 1) }
  AppProperty { id: deckKillMidLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.kill_mid_low"; onValueChanged: (lastTouchedKnob = 2) }
  AppProperty { id: deckKillLow;  path: "app.traktor.mixer.channels." + deckIdx + ".eq.kill_low"; onValueChanged: (lastTouchedKnob = 2) }
  AppProperty { id: deckFxOn;  path: "app.traktor.mixer.channels." + deckIdx + ".fx.on"; onValueChanged: (lastTouchedKnob = 3) }
  AppProperty { id: deckFXAdjust;  path: "app.traktor.mixer.channels." + deckIdx + ".fx.adjust"  }
  AppProperty { id: mixerFXTypeProp; path: "app.traktor.mixer.channels." + deckIdx + ".fx.select"; onValueChanged: (lastTouchedKnob = 3) }
  property alias mixerFXType: mixerFXTypeProp.value
  readonly property variant mixerFXName: mixerFXTypeProp.description

  // AppProperty { id: stem1Filter; path: "app.traktor.decks." + deckIdx + ".stems.1.filter_value" }
  // AppProperty { id: stem2Filter; path: "app.traktor.decks." + deckIdx + ".stems.2.filter_value" }
  // AppProperty { id: stem3Filter; path: "app.traktor.decks." + deckIdx + ".stems.3.filter_value" }
  // AppProperty { id: stem4Filter; path: "app.traktor.decks." + deckIdx + ".stems.4.filter_value" }

  MappingProperty { id: stemVolumeFilterProp_1; path: "mapping.state." + deckIdx + ".stems_1_volume_filter" }
  MappingProperty { id: stemVolumeFilterProp_2; path: "mapping.state." + deckIdx + ".stems_2_volume_filter" }
  MappingProperty { id: stemVolumeFilterProp_3; path: "mapping.state." + deckIdx + ".stems_3_volume_filter" }
  MappingProperty { id: stemVolumeFilterProp_4; path: "mapping.state." + deckIdx + ".stems_4_volume_filter" }
  MappingProperty { id: remixPlayersVolumeFilterProp_1; path: "mapping.state." + deckIdx + ".remix_players_1_volume_filter" }
  MappingProperty { id: remixPlayersVolumeFilterProp_2; path: "mapping.state." + deckIdx + ".remix_players_2_volume_filter" }
  MappingProperty { id: remixPlayersVolumeFilterProp_3; path: "mapping.state." + deckIdx + ".remix_players_3_volume_filter" }
  MappingProperty { id: remixPlayersVolumeFilterProp_4; path: "mapping.state." + deckIdx + ".remix_players_4_volume_filter" }

  // AppProperty { id: stem1Mute; path: "app.traktor.decks." + deckIdx + ".stems.1.muted"; onValueChanged: (lastTouchedKnob = 1) }
  // AppProperty { id: stem2Mute; path: "app.traktor.decks." + deckIdx + ".stems.2.muted"; onValueChanged: (lastTouchedKnob = 2) }
  // AppProperty { id: stem3Mute; path: "app.traktor.decks." + deckIdx + ".stems.3.muted"; onValueChanged: (lastTouchedKnob = 3) }
  // AppProperty { id: stem4Mute; path: "app.traktor.decks." + deckIdx + ".stems.4.muted"; onValueChanged: (lastTouchedKnob = 4) }
  AppProperty { id: stems1FxSend; path: "app.traktor.decks." + deckIdx + ".stems.1.fx_send_on"; onValueChanged: (lastTouchedKnob = 1) }
  AppProperty { id: stems2FxSend; path: "app.traktor.decks." + deckIdx + ".stems.2.fx_send_on"; onValueChanged: (lastTouchedKnob = 2) }
  AppProperty { id: stems3FxSend; path: "app.traktor.decks." + deckIdx + ".stems.3.fx_send_on"; onValueChanged: (lastTouchedKnob = 3) }
  AppProperty { id: stems4FxSend; path: "app.traktor.decks." + deckIdx + ".stems.4.fx_send_on"; onValueChanged: (lastTouchedKnob = 4) }
  AppProperty { id: remixSlot1FxSend; path: "app.traktor.decks." + deckIdx + ".remix.players.1.fx_send_on"; onValueChanged: (lastTouchedKnob = 1) }
  AppProperty { id: remixSlot2FxSend; path: "app.traktor.decks." + deckIdx + ".remix.players.2.fx_send_on"; onValueChanged: (lastTouchedKnob = 2) }
  AppProperty { id: remixSlot3FxSend; path: "app.traktor.decks." + deckIdx + ".remix.players.3.fx_send_on"; onValueChanged: (lastTouchedKnob = 3) }
  AppProperty { id: remixSlot4FxSend; path: "app.traktor.decks." + deckIdx + ".remix.players.4.fx_send_on"; onValueChanged: (lastTouchedKnob = 4) }

  function onFxChanged()
  {
    lastTouchedKnob = 1;
  }

  function onLayerChanged()
  {
    switch(fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
        // Defaults to Dry/Wet
        lastTouchedKnob = 1;
        break;

      case FXSectionLayer.mixer:
        // Defaults to Volume
        lastTouchedKnob = 4;
        break;
    }
  }

  function hasParameter(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch (fxUnitType.value)
        {
          case FxType.Group:
          {
            switch(knob)
            {
              case 1: return true;
              case 2: return fxSelect1.value !== 0;
              case 3: return fxSelect2.value !== 0;
              case 4: return fxSelect3.value !== 0;
            }

            break;
          }

          case FxType.Single:
          {
            if (fxSelect1.value === 0)
              return false;

            switch(knob)
            {
              case 1: return true;
              case 2: return fxParameterName1.value.length !== 0;
              case 3: return fxParameterName2.value.length !== 0;
              case 4: return fxParameterName3.value.length !== 0;
            }

            break;
          }

          case FxType.PatternPlayer:
            return true;
        }

        break;
      }

      case FXSectionLayer.mixer:
        return true;
    }

    return false;
  }

  function parameterName(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch (fxUnitType.value)
        {
          case FxType.Group:
          {
            switch(knob)
            {
              case 1: return "D/W";
              case 2: return DisplayHelpers.effectName(fxSelect1.description);
              case 3: return DisplayHelpers.effectName(fxSelect2.description);
              case 4: return DisplayHelpers.effectName(fxSelect3.description);
            }

            break;
          }

          case FxType.Single:
          {
            return DisplayHelpers.parameterName(fxSelect1.description, knob);
          }

          case FxType.PatternPlayer:
          {
            switch(knob)
            {
              case 1: return "VOL";
              case 2: return "PTRN";
              case 3: return "PTCH";
              case 4: return "DCAY";
            }

            break;
          }
        }

        break;
      }

      case FXSectionLayer.mixer:
      {
        // switch(knob)
        // {
          // case 1: return "HI";
          // case 2: return "MID";
          // case 3: return "LO";
          // case 4: return "VOL";
        // }
        // break;
        if (isStemOverlayActive) {
          switch(knob) {
            case 1: return "DRUM";
            case 2: return "BASS";
            case 3: return "OTHR";
            case 4: return "VOCL";
          }
          break;
        }
        else if (isRemixOverlayActive) {
          switch(knob) {
            case 1: return "SLT.1";
            case 2: return "SLT.2";
            case 3: return "SLT.3";
            case 4: return "SLT.4";
          }
          break;
        }
        else {
          switch(knob) {
            case 1: return shift ? "MID" : "HI";
            // case 2: return (customMixerMidLow && shift) ? "M.LO" : "LO";
            case 2: return (customMixerMidLow && ((!customMixerLowOnShift && shift) || (customMixerLowOnShift && !shift))) ? "M.LO" : "LO";
            case 3: return "" + mixerFXName;
            case 4: return ((!customMixerVolumeOnShift && !shift) || (customMixerVolumeOnShift && shift)) ? "VOL" : "GAIN";
          }
          break;
        }
      }
    }

    return "";
  }

  function parameterValue(knob)
  {
    switch (fxSectionLayer)
    {
      case FXSectionLayer.fx_primary:
      case FXSectionLayer.fx_secondary:
      {
        switch(knob)
        {
          case 1: return fxDryWet.description;
          case 2: return fxParameterValue1.description;
          case 3: return fxParameterValue2.description;
          case 4: return fxParameterValue3.description;
        }

        break;
      }

      case FXSectionLayer.mixer:
      {
        // switch(knob)
        // {
          // case 1: return (200.0 * deckEqHigh.value - 100.0).toFixed();
          // case 2: return (200.0 * deckEqMid.value  - 100.0).toFixed();
          // case 3: return (200.0 * deckEqLow.value  - 100.0).toFixed();
          // case 4: return (100.0 * deckVolume.value).toFixed();
        // }
        // break;
        if (isStemOverlayActive) {
          switch(knob) {
            // case 1: return Math.round((stem1Filter.value - 0.5) * 200);
            // case 2: return Math.round((stem2Filter.value - 0.5) * 200);
            // case 3: return Math.round((stem3Filter.value - 0.5) * 200);
            // case 4: return Math.round((stem4Filter.value - 0.5) * 200);
            case 1: return Math.round((stemVolumeFilterProp_1.value - 0.5) * 200);
            case 2: return Math.round((stemVolumeFilterProp_2.value - 0.5) * 200);
            case 3: return Math.round((stemVolumeFilterProp_3.value - 0.5) * 200);
            case 4: return Math.round((stemVolumeFilterProp_4.value - 0.5) * 200);
          }
          break;
        }
        else if (isRemixOverlayActive) {
          switch(knob) {
            case 1: return Math.round((remixPlayersVolumeFilterProp_1.value - 0.5) * 200);
            case 2: return Math.round((remixPlayersVolumeFilterProp_2.value - 0.5) * 200);
            case 3: return Math.round((remixPlayersVolumeFilterProp_3.value - 0.5) * 200);
            case 4: return Math.round((remixPlayersVolumeFilterProp_4.value - 0.5) * 200);
          }
          break;
        }
        else {
          switch(knob) {
            case 1: return shift ? (200.0 * deckEqMid.value  - 100.0).toFixed() : (200.0 * deckEqHigh.value - 100.0).toFixed();
            // case 2: return (customMixerMidLow && shift) ? (200.0 * deckEqMidLow.value  - 100.0).toFixed() : (200.0 * deckEqLow.value  - 100.0).toFixed();
            case 2: return (customMixerMidLow && ((!customMixerLowOnShift && shift) || (customMixerLowOnShift && !shift))) ? (200.0 * deckEqMidLow.value  - 100.0).toFixed() : (200.0 * deckEqLow.value  - 100.0).toFixed();
            case 3: return (200.0 * deckFXAdjust.value  - 100.0).toFixed();
            case 4: return ((!customMixerVolumeOnShift && !shift) || (customMixerVolumeOnShift && shift)) ? (100.0 * deckVolume.value).toFixed() : (200.0 * deckGain.value - 100.0).toFixed();
          }
          break;
        }
      }
    }

    return "";
  }

  MappingProperty { id: blinkerProp; path: "mapping.state.blinker" }
  property alias blinkOnOff: blinkerProp.value

  readonly property bool isSingleGroupFx: (fxSectionLayer === FXSectionLayer.fx_primary || fxSectionLayer === FXSectionLayer.fx_secondary) && (fxUnitType.value !== FxType.PatternPlayer)
  readonly property bool isPatternPlayer: (fxSectionLayer === FXSectionLayer.fx_primary || fxSectionLayer === FXSectionLayer.fx_secondary) && (fxUnitType.value === FxType.PatternPlayer)

  Rectangle {
    color: "black"
    anchors.fill: parent

    Item
    {
      visible: deviceSetupState == DeviceSetupState.assigned
      anchors.fill: parent

      // Single/Group Fx Title
      ThickText {
        visible: isSingleGroupFx

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
            leftMargin: 1
        }

        text: fxUnitType.value === FxType.Single ? fxSelect1.description : "FX GROUP"
        wrapMode: Text.Wrap
      }

      // Pattern Player Kit
      ThickText {
        visible: isPatternPlayer

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 0
            leftMargin: 1
        }

        text: currentKit.description
        wrapMode: Text.NoWrap
      }

      // Pattern Player Sound
      ThickText {
        visible: isPatternPlayer

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 16
            leftMargin: 1
        }

        text: currentSound.description
        wrapMode: Text.NoWrap
      }

      // Pattern Player view
      Item
      {
        visible: isPatternPlayer && (!knobsAreActive || lastTouchedKnob == 2)
        anchors.fill: parent

        AnimatedImage {
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 13
                rightMargin: 6
            }
            visible:   (softTakeoverDirection !== 0) && hasParameter(lastTouchedKnob)
            source:    softTakeoverDirection === 1 ? "Images/SoftTakeoverUp.gif" : "Images/SoftTakeoverDown.gif"
            fillMode:  Image.PreserveAspectFit
        }
        
        Repeater {
          model: 16
          Rectangle
          {
            AppProperty { id: stepState;  path: "app.traktor.fx." + fxUnitIdx + ".pattern_player.steps." + (index + 1) + ".state"  }

            anchors {
              left: parent.left
              bottom: parent.bottom
              leftMargin: (index % 8) * 16
              bottomMargin: (index < 8) ? 16 : 0
            }
            border {
              width: 1
              color: "white"
            }

            width: 12
            height: 12
            color: stepState.value ? "white" : "black"

            Rectangle
            {
                visible: currentStep.value == index

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }

                width: 4
                height: 4
                color: stepState.value ? "black" : "white"
            }
          }
        }
      }

      // Parameter overlay
      Item
      {
        visible: !(isPatternPlayer && (!knobsAreActive || lastTouchedKnob == 2))
        anchors.fill: parent

        Image {
          anchors {
              top: parent.top
              left: parent.left
          }

          source:    "Images/Indicator.png"
          fillMode:  Image.PreserveAspectFit
          visible: fxSectionLayer == FXSectionLayer.mixer && deckCue.value
        }

        ThinText {
            anchors {
                bottom: parent.bottom
                left: parent.left
                leftMargin: -13
                bottomMargin: -5
            }
            font.capitalization: Font.AllUppercase
            text: " " + (hasParameter(lastTouchedKnob) ? parameterName(lastTouchedKnob) : "EMPTY")
        }

        ThinText {
            id: valueText

            anchors {
                bottom: parent.bottom
                right: parent.right
                bottomMargin: -5
                rightMargin: -3
            }
            font.capitalization: Font.AllUppercase
            text: " " + (hasParameter(lastTouchedKnob) ? parameterValue(lastTouchedKnob) : "")
        }

        AnimatedImage {
            anchors {
                bottom: parent.bottom
                right: valueText.left
                rightMargin: -10
            }
            visible:   (softTakeoverDirection !== 0) && hasParameter(lastTouchedKnob)
            source:    softTakeoverDirection === 1 ? "Images/SoftTakeoverUp.gif" : "Images/SoftTakeoverDown.gif"
            fillMode:  Image.PreserveAspectFit
        }
      }
    }

    // Deck assignment
    Item {
      visible: deviceSetupState == DeviceSetupState.unassigned && lastTouchedButton == 0
      anchors.fill: parent

      Rectangle {
        color: blinkOnOff ? "white" : "black"
        anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        }

        width: 120
        height: 44

        ThinText {
          anchors {
            top: parent.top
            left: parent.left
            topMargin: -10
            leftMargin: -20
          }
          font.pixelSize: 60
          font.capitalization: Font.AllUppercase

          text: " " + fxText[primaryFxUnitProp.value - 1]
          color: blinkOnOff ? "black" : "white"
        }
      }
    }
    // Deck assignment
    Item {
      visible: deviceSetupState == DeviceSetupState.unassigned && lastTouchedButton != 0
      anchors.fill: parent

      Rectangle {
        color: blinkOnOff ? "white" : "black"
        anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        }

        width: 120
        height: 44

        ThinText {
          anchors {
            top: parent.top
            left: parent.left
            topMargin: -10
            leftMargin: -20
          }
          font.pixelSize: 30
          font.capitalization: Font.AllUppercase

          text: "  " + setupTextA[lastTouchedButton]
          color: blinkOnOff ? "black" : "white"
        }
        ThinText {
          anchors {
            bottom: parent.bottom
            left: parent.left
            bottomMargin: -10
            leftMargin: -20
          }
          font.pixelSize: 30
          font.capitalization: Font.AllUppercase

          text: "  " + setupTextB[lastTouchedButton]
          color: blinkOnOff ? "black" : "white"
        }
      }
    }
    
  }
  
}
