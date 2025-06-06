import CSI 1.0
import QtQuick 2.0

import "../Defines" as Defines
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

  readonly property variant deckText: ["A", "B", "C", "D"]
  readonly property variant loopText: ["'32", "'16", "'8", "'4", "'2", "1", "2", "4", "8", "16", "32"]

  readonly property int remainingTimeInfo: 0
  readonly property int elapsedTimeInfo:   1
  readonly property int loopSizeInfo:      2

  MappingProperty { id: deckIdxProp; path: screen.propertiesPath + ".deck_index" }
  property alias deckIdx: deckIdxProp.value

  MappingProperty { id: leftDeckIdxProp; path: "mapping.settings.left_deck_index" }
  property alias leftDeckIdx: leftDeckIdxProp.value

  readonly property bool isLeftScreen: (deckIdx == leftDeckIdx) ? true : false

  MappingProperty { id: showEndWarningProp; path: "mapping.settings.bottom_leds.show_end_warning" }
  
  MappingProperty { id: showLoopSizeProp; path: screen.propertiesPath + ".show_loop_size" }
  property alias showLoopSize: showLoopSizeProp.value

  MappingProperty { id: syncModifierProp; path: screen.propertiesPath + ".sync_modifier" }
  property alias showBPMInfo: syncModifierProp.value

  MappingProperty { id: shiftProp; path: "mapping.state.shift" }
  property alias shift: shiftProp.value

  MappingProperty { id: deviceSetupStateProp; path: "mapping.state.device_setup_state" }
  property alias deviceSetupState: deviceSetupStateProp.value

  MappingProperty { id: deckDisplayMainInfoProp; path: "mapping.settings.deck_display.main_info" }
  property alias deckDisplayMainInfo: deckDisplayMainInfoProp.value

  MappingProperty { id: loopShiftActionProp; path: "mapping.settings.loop_shift_action" }
  property alias loopShiftAction: loopShiftActionProp.value

  Defines.Utils  { id: utils }

  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + deckIdx + ".type" }
  property bool isRemixDeck: (deckTypeProp.value === DeckType.Remix)
  AppProperty { id: deckPlayProp; path: "app.traktor.decks." + deckIdx + ".play" }
  AppProperty { id: trackTitleProp; path: "app.traktor.decks." + deckIdx + ".content.title" }
  AppProperty { id: trackLengthProp; path: "app.traktor.decks." + deckIdx + ".track.content.track_length" }
  AppProperty { id: elapsedTimeProp; path: "app.traktor.decks." + deckIdx + ".track.player.elapsed_time"  }
  AppProperty { id: trackEndWarningProp; path: "app.traktor.decks." + deckIdx + ".track.track_end_warning" }

  AppProperty { id: remixBeatPosProp; path: "app.traktor.decks." + deckIdx + ".remix.current_beat_pos" }
  readonly property string  beatPositionString:   remixBeatPosProp.description

  AppProperty { id: trackBPMProp;      path: "app.traktor.decks." + deckIdx + ".tempo.base_bpm" }

  AppProperty { id: nextCuePointProp; path: "app.traktor.decks." + deckIdx + ".track.player.next_cue_point" }
  readonly property double cuePos: (nextCuePointProp.value >= 0) ? nextCuePointProp.value : trackLengthProp.value * 1000
  readonly property string beatsToCue: computeBarsBeatsFromPosition(((elapsedTimeProp.value * 1000 - cuePos) * trackBPMProp.value) / 60000.0)

  AppProperty { id: loopSizeProp; path: "app.traktor.decks." + deckIdx + ".loop.size" }
  AppProperty { id: loopActiveProp; path: "app.traktor.decks." + deckIdx + ".loop.active" }

  AppProperty { id: tempoBpmProp; path: "app.traktor.decks." + deckIdx + ".tempo.adjust_bpm" }

  AppProperty { id: keyAdjustProp; path: "app.traktor.decks." + deckIdx + ".track.key.adjust" }
  AppProperty { id: keyLockProp; path: "app.traktor.decks." + deckIdx + ".track.key.lock_enabled" }
  readonly property string  keyAdjustText: keyLockProp.value ? (keyAdjustProp.value < 0 ? "" : "+") + (keyAdjustProp.value * 12).toFixed(0).toString() : ""
  AppProperty { id: resultingKeyProp; path: "app.traktor.decks." + deckIdx + ".track.key.resulting.quantized" }

  readonly property bool isLoaded: (trackLengthProp.value > 0) || (deckTypeProp.value === DeckType.Remix)
  readonly property string remainingTime: isLoaded ? utils.computeRemainingTimeString(trackLengthProp.value, elapsedTimeProp.value) : "00:00"
  readonly property string elapsedTime: isLoaded ? utils.convertToTimeString(elapsedTimeProp.value) : "00:00"

  // Loop encoder actions
  readonly property int beatjump_loop:      0
  readonly property int key_adjust:         1

  MappingProperty { id: blinkerProp; path: "mapping.state.blinker" }
  property alias blinkOnOff: blinkerProp.value

  MappingProperty { id: customBeatCounterEngagedProp; path: "mapping.settings.custom_beatcounter_engaged" }
  property alias customBeatCounterEngaged: customBeatCounterEngagedProp.value
  MappingProperty { id: customBeatCounterPhraseLengthProp; path: "mapping.settings.custom_phrase_length" }
  property alias customBeatCounterPhraseLength: customBeatCounterPhraseLengthProp.value

  MappingProperty { id: browserModeProp; path: "mapping.state.browser_mode" }
  MappingProperty { id: customBrowserModeProp; path: "mapping.settings.custom_browser_mode" }
  // AppProperty { id: browserFullScreen; path:"app.traktor.browser.full_screen" }
  AppProperty { id: previewLengthProp; path: "app.traktor.browser.preview_content.track_length" }
  AppProperty { id: previewElapsedTimeProp; path: "app.traktor.browser.preview_player.elapsed_time"  }
  AppProperty { id: previewDeckLoadedProp; path: "app.traktor.browser.preview_player.is_loaded"  }
  AppProperty { id: previewDeckPlayingProp; path: "app.traktor.browser.preview_player.play"  }

  //----------------------------------------------------------------------------------------------------------

  function computeBarsBeatsFromPosition(beat) {    
    var phraseLen   = Math.pow (2, customBeatCounterPhraseLength) // 8 // 4
    var rawInt      = parseInt(beat+0.0001); //value 0.0001 to counter rounding error offset
    var prefix      = (beat < 0) ? "-" : "";    
    var absBeats    = Math.abs(rawInt);    
    var phrases     = parseInt(absBeats / (phraseLen * 4) ) + 1; 
    var bars        = parseInt((absBeats / 4) % phraseLen) + 1;
    var phrasesBars = (customBeatCounterPhraseLength == 0) ? phrases + "." : phrases + "." + bars + "."
    var beatInBar   = parseInt(absBeats % 4) + 1;
    // return prefix + phrases + "." + bars + "." + beatInBar;
    return prefix + phrasesBars + beatInBar;
  }

  //----------------------------------------------------------------------------------------------------------
  Rectangle {
    color: "black"
    anchors.fill: parent

    // Track/Stem/Remix Deck
    Item
    {
      visible: (deviceSetupState == DeviceSetupState.assigned) && (deckTypeProp.value != DeckType.Live)
      anchors.fill: parent

      Item
      {
        // visible: !showLoopSize && !showBPMInfo
        visible: !showLoopSize && !showBPMInfo && !browserModeProp.value
        anchors.fill: parent

        // Track title
        ThickText {
            visible: !shift

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
                leftMargin: 1
            }
            text: trackTitleProp.value
        }

        // Remaining/Elapsed Time
        ThinText {
            visible: (deckDisplayMainInfo != loopSizeInfo) && !shift && !customBeatCounterEngaged && !isRemixDeck

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: -13
                topMargin: 19
            }
            font.pixelSize: 32
            font.capitalization: Font.AllUppercase
            text: " " + (deckDisplayMainInfo == elapsedTimeInfo ? elapsedTime : remainingTime)
            // text: " " + customBeatCounterEngaged ? (deckDisplayMainInfo == elapsedTimeInfo ? elapsedTime : beatsToCue) : (deckDisplayMainInfo == elapsedTimeInfo ? elapsedTime : remainingTime)
            // remixBeatPosProp
            color: !trackEndWarningProp.value || screen.blinkOnOff ? "white" : "black"
        }

        // Remaining/Elapsed [Phrases].[Bars].[Beats]
        ThinText {
            visible: (deckDisplayMainInfo != loopSizeInfo) && !shift && customBeatCounterEngaged && !isRemixDeck

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: -13
                topMargin: 19
            }
            font.pixelSize: 32
            font.capitalization: Font.AllUppercase
            text: " " + (deckDisplayMainInfo == elapsedTimeInfo ? elapsedTime : beatsToCue)
            color: !trackEndWarningProp.value || screen.blinkOnOff ? "white" : "black"
        }

        // Remix Deck Beat Counter
        ThinText {
            visible: (deckDisplayMainInfo != loopSizeInfo) && !shift && isRemixDeck

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: -13
                topMargin: 19
            }
            font.pixelSize: 32
            font.capitalization: Font.AllUppercase
            text: " " + beatPositionString
            color: !trackEndWarningProp.value || screen.blinkOnOff ? "white" : "black"
        }

        // Loop headline
        ThickText {
            // visible: shift && loopShiftAction == beatjump_loop
            // visible: false
            visible: shift && !customBrowserModeProp.value && (loopShiftAction == beatjump_loop)

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
                leftMargin: 1
            }
            text: loopActiveProp.value ? "LOOP MOVE" : "BEATJUMP"
        }

        // Loop size (big)
        Rectangle {
          // visible: (deckDisplayMainInfo == loopSizeInfo) || (shift && loopShiftAction == beatjump_loop)
          // visible: (deckDisplayMainInfo == loopSizeInfo)
          visible: (deckDisplayMainInfo == loopSizeInfo) || ( shift && !customBrowserModeProp.value && (loopShiftAction == beatjump_loop) )

          anchors {
              top: parent.top
              left: parent.left
              leftMargin: -13
              topMargin: 20
          }
          width: 85
          height: 35
          color: loopActiveProp.value ? "white" : "black"

          ThinText {
              anchors.fill: parent 
              font.pixelSize: 48
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignHCenter

              text: " " + screen.loopText[loopSizeProp.value]
              color: loopActiveProp.value ? "black" : "white"
          }
        }

        // Assigned deck
        Rectangle {
          visible: !shift

          color: deckPlayProp.value ? "white" : "black"
          anchors {
            top: parent.top
            right: parent.right

            rightMargin: 0
            topMargin: 35
          }
          width: 32
          height: 19

          ThinText {
              anchors.fill: parent
              anchors.rightMargin: 7
              font.pixelSize: 24
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignHCenter

              text: " " + screen.deckText[deckIdx - 1]
              color: deckPlayProp.value ? "black" : "white"
          }
        }

        // [SHIFT] Remaining time
        ThickText {
            visible: shift && customBeatCounterEngaged && (customBrowserModeProp.value || (!customBrowserModeProp.value && (loopShiftAction == key_adjust) ) )

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
                leftMargin: 1
            }
            text: " " + (deckDisplayMainInfo == elapsedTimeInfo ? elapsedTime : remainingTime)
        }
        
        // Resulting key (big)
        Rectangle {
          // visible: shift && (loopShiftAction == key_adjust)
          // visible: shift
          visible: shift && (customBrowserModeProp.value || (!customBrowserModeProp.value && (loopShiftAction == key_adjust) ) )

          anchors {
              top: parent.top
              left: parent.left
              leftMargin: -13
              topMargin: 20
          }
          width: 85
          height: 35
          color: "black"

          ThinText {
              anchors.fill: parent 
              font.pixelSize: 48
              horizontalAlignment: Text.AlignHCenter

              text: " " + resultingKeyProp.value
              color: "white"
          }
        }

        // Key offset
        Rectangle {
          // visible: shift && (loopShiftAction == key_adjust)
          // visible: shift
          visible: shift && (customBrowserModeProp.value || (!customBrowserModeProp.value && (loopShiftAction == key_adjust) ) )

          color: "black"
          anchors {
            top: parent.top
            right: parent.right

            rightMargin: 0
            topMargin: 35
          }
          width: 32
          height: 19

          ThinText {
              anchors.fill: parent
              anchors.rightMargin: 7
              font.pixelSize: 24
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignHCenter

              text: " " + keyAdjustText
              color: "white"
          }
        }

        // Loop size (small)
        Rectangle {
          visible: (deckDisplayMainInfo != loopSizeInfo) && !shift

          color: loopActiveProp.value ? "white" : "black"
          anchors {
            top: parent.top
            right: parent.right

            rightMargin: 0
            topMargin: 14
          }
          width: 32
          height: 19

          ThinText {
              anchors.fill: parent
              anchors.rightMargin: 7
              font.pixelSize: 24
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignHCenter

              text: " " + screen.loopText[loopSizeProp.value]
              color: loopActiveProp.value ? "black" : "white"
          }
        }
      }

      // Loop Overlay
      Item {
        // visible: showLoopSize && !showBPMInfo
        visible: showLoopSize && !showBPMInfo && !browserModeProp.value
        anchors.fill: parent

        // Loop headline
        ThickText {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
                leftMargin: 1
            }
            text: "LOOP"
        }

        // Loop size
        Rectangle {
          anchors {
              top: parent.top
              left: parent.left
              leftMargin: -13
              topMargin: 20
          }
          width: 85
          height: 35
          color: loopActiveProp.value ? "white" : "black"

          ThinText {
              anchors.fill: parent 
              font.pixelSize: 48
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignHCenter

              text: " " + screen.loopText[loopSizeProp.value]
              color: loopActiveProp.value ? "black" : "white"
          }
        }
      }

      // BPM Overlay
      Item {
        // visible: !showLoopSize && showBPMInfo
        visible: !showLoopSize && showBPMInfo && !browserModeProp.value
        anchors.fill: parent

        // BPM
        Rectangle {
          anchors {
              top: parent.top
              left: parent.left
              leftMargin: -13
              topMargin: 20
          }
          width: parent.width
          height: 35
          color: "black"

          ThinText {
              anchors.fill: parent 
              font.pixelSize: 48
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignLeft

              text: " " + tempoBpmProp.value.toFixed(2).toString()
              color: "white"
          }
        }
      }

      // BrowserMode Overlay
      Item {
        visible: browserModeProp.value
        anchors.fill: parent

        // Browse Headline
          ThinText {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 0
                leftMargin: 4
            }
            font.pixelSize: 18
            font.capitalization: Font.AllUppercase
            text: "BROWSE LIST"
        }
        
        Rectangle {
          anchors {
              top: parent.top
              left: parent.left
              // leftMargin: -13
              leftMargin: 2
              topMargin: 20
          }
          width: parent.width
          height: 35
          color: "black"

          ThinText {
              anchors.fill: parent 
              font.pixelSize: 18
              font.capitalization: Font.AllUppercase
              horizontalAlignment: Text.AlignLeft

              text:  isLeftScreen ? " BROWSE TREE" : shift ? "FAVORITES PREP" : "PREVIEW PLAYER"
              color:  isLeftScreen || shift ? "white" : previewDeckPlayingProp.value && screen.blinkOnOff ? "black" : "white"
          }
        }
      }

      // Track progress
      Rectangle {
        z: 1
        color: "black"
        visible: !browserModeProp.value
        anchors {
          bottom: parent.bottom
          left: parent.left

          leftMargin: 0
          bottomMargin: 0
        }
        border {
          color: "white"
          width: 1
        }
        width: screen.width
        height: 6

        Rectangle {
          // color: !trackEndWarningProp.value || screen.blinkOnOff ? "white" : "black"
          color: (!trackEndWarningProp.value || screen.blinkOnOff) || showEndWarningProp.value ? "white" : "black"
          anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 1
          }
          width: isLoaded ? Math.round(screen.width * elapsedTimeProp.value / trackLengthProp.value) : 0
        }
      }
    }

      // Preview Player progress
      Rectangle {
        z: 1
        color: "black"
        visible: browserModeProp.value && !(isLeftScreen)
        anchors {
          bottom: parent.bottom
          left: parent.left

          leftMargin: 0
          bottomMargin: 0
        }
        border {
          color: "white"
          width: 1
        }
        width: screen.width
        height: 6

        Rectangle {
          color: "white"
          anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            margins: 1
          }
          width: previewDeckLoadedProp.value ? Math.round(screen.width * previewElapsedTimeProp.value / previewLengthProp.value) : 0
        }
      }
      
    // Live Deck
    Item
    {
      visible: (deviceSetupState == DeviceSetupState.assigned) && (deckTypeProp.value == DeckType.Live)
      anchors.fill: parent

      ThinText {
          anchors.fill: parent
          text: "LIVE INPUT"
          horizontalAlignment: Text.AlignHCenter
          wrapMode: Text.WordWrap
          lineHeight: 29
          lineHeightMode: Text.FixedHeight
      }
    }

    // Deck assignment
    Item {
      // visible: deviceSetupState == DeviceSetupState.unassigned
      visible: deviceSetupState != DeviceSetupState.assigned
      anchors.fill: parent

      Rectangle {
        color: blinkOnOff ? "white" : "black"
        anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
        }

        width: 44
        height: 44

        ThinText {
          anchors {
            top: parent.top
            left: parent.left
            topMargin: -10
            leftMargin: -15
          }
          font.pixelSize: 60
          font.capitalization: Font.AllUppercase

          text: " " + deckText[screen.deckIdx - 1]
          color: blinkOnOff ? "black" : "white"
        }
      }
    }
  }
}
