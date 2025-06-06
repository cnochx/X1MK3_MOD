import CSI 1.0
import QtQuick 2.5

import "Defines"
import "../../Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property bool syncModifier: false
  property int deckIdx: 0
  property string surface: ""
  property string propertiesPath: ""

  property int fxSectionLayer: FXSectionLayer.fx_primary
  property int leftPrimaryFxIdx: 0
  property int rightPrimaryFxIdx: 0
  property int leftSecondaryFxIdx: 0
  property int rightSecondaryFxIdx: 0

  property string fxAssignmentPropertiesPath: ""
  property int sidePrimaryFxIdx: 0
  property int sideSecondaryFxIdx: 0

  // Settings
  property int nudgePushAction: 0
  property int nudgeShiftPushAction: 0

  property int hotcue12PushAction: 0
  property int hotcue34PushAction: 0
  property int hotcue12ShiftPushAction: 0
  property int hotcue34ShiftPushAction: 0

  property int browseShiftAction: 0
  property int browseShiftPushAction: 0

  property int loopShiftAction: 0

  property bool showEndWarning: false
  property bool showSyncWarning: false
  property bool showActiveLoop: false
  property int  bottomLedsDefaultColor: 0

  // Loop encoder actions
  readonly property int beatjump_loop:      0
  readonly property int key_adjust:         1

  property bool shouldShowEndWarning: showEndWarning && trackEndWarningProp.value
  property bool shouldShowActiveLoop: showActiveLoop && inActiveLoopProp.value
  property bool shouldShowSyncWarning: showSyncWarning && syncProp.value && (Math.abs(phaseProp.value) >= 0.008)

  property bool coarseTempoStep: false
  property bool resetTempoEngaged: false

  // AppProperty { id: browserFullScreenProp; path:"app.traktor.browser.full_screen" }
  AppProperty { id: inActiveLoopProp; path: "app.traktor.decks." + module.deckIdx + ".loop.is_in_active_loop" }
  // AppProperty { id: endWarningProp; path: "app.traktor.decks." + module.deckIdx + ".track.track_end_warning" }
  AppProperty { id: trackEndWarningProp; path: "app.traktor.decks." + module.deckIdx + ".track.track_end_warning" }

  AppProperty { id: syncProp; path: "app.traktor.decks." + module.deckIdx + ".sync.enabled" }
  AppProperty { id: isSyncTriggeredProp; path: "app.traktor.decks." + module.deckIdx + ".sync.tempo" }
  AppProperty { id: phaseProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.phase" }

  AppProperty { id: tempoAdjProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.adjust" }
  AppProperty { id: tempoAbsProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.absolute" }
  AppProperty { id: trackBaseBPMProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.base_bpm" }
  AppProperty { id: bpmProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.adjust_bpm" }
  AppProperty { id: masterIdProp; path: "app.traktor.masterclock.source_id" } //-1: MasterClock, 0: Deck A, 1: Deck B, 2: Deck C, 3: Deck D
  property int masterId: masterIdProp.value + 1
  property bool isSlaveDeck: syncProp.value && (module.masterId != module.deckIdx)

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units" }

  // Browser
  AppProperty { id: loadPrimary; path: "app.traktor.decks." + module.deckIdx + ".load.selected" }
  AppProperty { id: loadSecondary; path: "app.traktor.decks." + module.deckIdx + ".load_secondary.selected" }
  
  // Stem Properties
  AppProperty { id: stemVolumeProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.volume"; }
  AppProperty { id: stemVolumeProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.volume"; }
  AppProperty { id: stemVolumeProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.volume"; }
  AppProperty { id: stemVolumeProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.volume"; }
  AppProperty { id: stemMutedProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.muted"; }
  AppProperty { id: stemMutedProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.muted"; }
  AppProperty { id: stemMutedProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.muted"; }
  AppProperty { id: stemMutedProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.muted"; }
  AppProperty { id: stemFilterProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.filter_value"; }
  AppProperty { id: stemFilterProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.filter_value"; }
  AppProperty { id: stemFilterProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.filter_value"; }
  AppProperty { id: stemFilterProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.filter_value"; }
  AppProperty { id: stemFilterOnProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.filter_on"; }
  AppProperty { id: stemFilterOnProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.filter_on"; }
  AppProperty { id: stemFilterOnProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.filter_on"; }
  AppProperty { id: stemFilterOnProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.filter_on"; }
  AppProperty { id: stemFxSendProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.fx_send"; }
  AppProperty { id: stemFxSendProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.fx_send"; }
  AppProperty { id: stemFxSendProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.fx_send"; }
  AppProperty { id: stemFxSendProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.fx_send"; }
  AppProperty { id: stemFxSendOnProp_1; path: "app.traktor.decks." + module.deckIdx + ".stems.1.fx_send_on"; }
  AppProperty { id: stemFxSendOnProp_2; path: "app.traktor.decks." + module.deckIdx + ".stems.2.fx_send_on"; }
  AppProperty { id: stemFxSendOnProp_3; path: "app.traktor.decks." + module.deckIdx + ".stems.3.fx_send_on"; }
  AppProperty { id: stemFxSendOnProp_4; path: "app.traktor.decks." + module.deckIdx + ".stems.4.fx_send_on"; }
  
/*
  The 'stemVolumeFilterUpdateTimer_X' timers are each triggered when the 'stemVolumeFilterProp_X'-parameter is changed, once because 'triggeredOnStart: true', and once (an additional, or second time) when the timer runs out 10ms after it's last use to make sure the parameters are always aligned correctly.
*/

  MappingPropertyDescriptor {
    id: stemVolumeFilterProp_1
    path: "mapping.state." + module.deckIdx + ".stems_1_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      stemVolumeFilterUpdateTimer_1.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: stemVolumeFilterUpdateTimer_1
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (stemVolumeFilterProp_1.value > 0.5) {
        stemVolumeProp_1.value = 1.0
        stemFilterProp_1.value = stemVolumeFilterProp_1.value
        stemFilterOnProp_1.value = true
      }
      else if (stemVolumeFilterProp_1.value < 0.5) {
        stemVolumeProp_1.value = stemVolumeFilterProp_1.value * 2
        stemFilterProp_1.value = 0.5
        stemFilterOnProp_1.value = false
      }
      else {
        stemVolumeProp_1.value = 1.0
        stemFilterProp_1.value = 0.5
        stemFilterOnProp_1.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: stemVolumeFilterProp_2
    path: "mapping.state." + module.deckIdx + ".stems_2_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      stemVolumeFilterUpdateTimer_2.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: stemVolumeFilterUpdateTimer_2
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (stemVolumeFilterProp_2.value > 0.5) {
        stemVolumeProp_2.value = 1.0
        stemFilterProp_2.value = stemVolumeFilterProp_2.value
        stemFilterOnProp_2.value = true
      }
      else if (stemVolumeFilterProp_2.value < 0.5) {
        stemVolumeProp_2.value = stemVolumeFilterProp_2.value * 2
        stemFilterProp_2.value = 0.5
        stemFilterOnProp_2.value = false
      }
      else {
        stemVolumeProp_2.value = 1.0
        stemFilterProp_2.value = 0.5
        stemFilterOnProp_2.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: stemVolumeFilterProp_3
    path: "mapping.state." + module.deckIdx + ".stems_3_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      stemVolumeFilterUpdateTimer_3.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: stemVolumeFilterUpdateTimer_3
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (stemVolumeFilterProp_3.value > 0.5) {
        stemVolumeProp_3.value = 1.0
        stemFilterProp_3.value = stemVolumeFilterProp_3.value
        stemFilterOnProp_3.value = true
      }
      else if (stemVolumeFilterProp_3.value < 0.5) {
        stemVolumeProp_3.value = stemVolumeFilterProp_3.value * 2
        stemFilterProp_3.value = 0.5
        stemFilterOnProp_3.value = false
      }
      else {
        stemVolumeProp_3.value = 1.0
        stemFilterProp_3.value = 0.5
        stemFilterOnProp_3.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: stemVolumeFilterProp_4
    path: "mapping.state." + module.deckIdx + ".stems_4_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      stemVolumeFilterUpdateTimer_4.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: stemVolumeFilterUpdateTimer_4
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (stemVolumeFilterProp_4.value > 0.5) {
        stemVolumeProp_4.value = 1.0
        stemFilterProp_4.value = stemVolumeFilterProp_4.value
        stemFilterOnProp_4.value = true
      }
      else if (stemVolumeFilterProp_4.value < 0.5) {
        stemVolumeProp_4.value = stemVolumeFilterProp_4.value * 2
        stemFilterProp_4.value = 0.5
        stemFilterOnProp_4.value = false
      }
      else {
        stemVolumeProp_4.value = 1.0
        stemFilterProp_4.value = 0.5
        stemFilterOnProp_4.value = false
      }
    }
  }

  // Remix Properties
  AppProperty { id: remixPlayersVolumeProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.volume"; }
  AppProperty { id: remixPlayersVolumeProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.volume"; }
  AppProperty { id: remixPlayersVolumeProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.volume"; }
  AppProperty { id: remixPlayersVolumeProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.volume"; }
  AppProperty { id: remixPlayersMutedProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.muted"; }
  AppProperty { id: remixPlayersMutedProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.muted"; }
  AppProperty { id: remixPlayersMutedProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.muted"; }
  AppProperty { id: remixPlayersMutedProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.muted"; }
  AppProperty { id: remixPlayersFilterProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.filter_value"; }
  AppProperty { id: remixPlayersFilterProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.filter_value"; }
  AppProperty { id: remixPlayersFilterProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.filter_value"; }
  AppProperty { id: remixPlayersFilterProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.filter_value"; }
  AppProperty { id: remixPlayersFilterOnProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.filter_on"; }
  AppProperty { id: remixPlayersFilterOnProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.filter_on"; }
  AppProperty { id: remixPlayersFilterOnProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.filter_on"; }
  AppProperty { id: remixPlayersFilterOnProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.filter_on"; }
  AppProperty { id: remixPlayersFxSendProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.fx_send"; }
  AppProperty { id: remixPlayersFxSendProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.fx_send"; }
  AppProperty { id: remixPlayersFxSendProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.fx_send"; }
  AppProperty { id: remixPlayersFxSendProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.fx_send"; }
  AppProperty { id: remixPlayersFxSendOnProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.fx_send_on"; }
  AppProperty { id: remixPlayersFxSendOnProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.fx_send_on"; }
  AppProperty { id: remixPlayersFxSendOnProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.fx_send_on"; }
  AppProperty { id: remixPlayersFxSendOnProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.fx_send_on"; }
  // AppProperty { id: remixPlayersActiveCellProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.active_cell_row"; }
  // AppProperty { id: remixPlayersActiveCellProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.active_cell_row"; }
  // AppProperty { id: remixPlayersActiveCellProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.active_cell_row"; }
  // AppProperty { id: remixPlayersActiveCellProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.active_cell_row"; }
  AppProperty { id: remixPlayersActiveCellProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.sequencer.selected_cell"; }
  AppProperty { id: remixPlayersActiveCellProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.sequencer.selected_cell"; }
  AppProperty { id: remixPlayersActiveCellProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.sequencer.selected_cell"; }
  AppProperty { id: remixPlayersActiveCellProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.sequencer.selected_cell"; }
  // AppProperty { id: remixPlayersColorIdProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.players.1.rows." + remixPlayersActiveCellProp_1.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.players.2.rows." + remixPlayersActiveCellProp_2.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.players.3.rows." + remixPlayersActiveCellProp_3.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.players.4.rows." + remixPlayersActiveCellProp_4.value + ".color_id"; }

  AppProperty { id: remixQuantProp; path: "app.traktor.decks." + module.deckIdx + ".remix.quant" }
  property bool quantizeEngaged: false
  property bool resetQuantizeEngaged: false
  MappingPropertyDescriptor { id: quantizeEngagedProp; path: propertiesPath + ".quantize_engaged"; type: MappingPropertyDescriptor.Boolean; value: false; }

  MappingPropertyDescriptor {
    id: remixPlayersVolumeFilterProp_1
    path: "mapping.state." + module.deckIdx + ".remix_players_1_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      remixPlayersVolumeFilterUpdateTimer_1.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: remixPlayersVolumeFilterUpdateTimer_1
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (remixPlayersVolumeFilterProp_1.value > 0.5) {
        remixPlayersVolumeProp_1.value = 1.0
        remixPlayersFilterProp_1.value = remixPlayersVolumeFilterProp_1.value
        remixPlayersFilterOnProp_1.value = true
      }
      else if (remixPlayersVolumeFilterProp_1.value < 0.5) {
        remixPlayersVolumeProp_1.value = remixPlayersVolumeFilterProp_1.value * 2
        remixPlayersFilterProp_1.value = 0.5
        remixPlayersFilterOnProp_1.value = false
      }
      else {
        remixPlayersVolumeProp_1.value = 1.0
        remixPlayersFilterProp_1.value = 0.5
        remixPlayersFilterOnProp_1.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: remixPlayersVolumeFilterProp_2
    path: "mapping.state." + module.deckIdx + ".remix_players_2_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      remixPlayersVolumeFilterUpdateTimer_2.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: remixPlayersVolumeFilterUpdateTimer_2
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (remixPlayersVolumeFilterProp_2.value > 0.5) {
        remixPlayersVolumeProp_2.value = 1.0
        remixPlayersFilterProp_2.value = remixPlayersVolumeFilterProp_2.value
        remixPlayersFilterOnProp_2.value = true
      }
      else if (remixPlayersVolumeFilterProp_2.value < 0.5) {
        remixPlayersVolumeProp_2.value = remixPlayersVolumeFilterProp_2.value * 2
        remixPlayersFilterProp_2.value = 0.5
        remixPlayersFilterOnProp_2.value = false
      }
      else {
        remixPlayersVolumeProp_2.value = 1.0
        remixPlayersFilterProp_2.value = 0.5
        remixPlayersFilterOnProp_2.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: remixPlayersVolumeFilterProp_3
    path: "mapping.state." + module.deckIdx + ".remix_players_3_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      remixPlayersVolumeFilterUpdateTimer_3.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: remixPlayersVolumeFilterUpdateTimer_3
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (remixPlayersVolumeFilterProp_3.value > 0.5) {
        remixPlayersVolumeProp_3.value = 1.0
        remixPlayersFilterProp_3.value = remixPlayersVolumeFilterProp_3.value
        remixPlayersFilterOnProp_3.value = true
      }
      else if (remixPlayersVolumeFilterProp_3.value < 0.5) {
        remixPlayersVolumeProp_3.value = remixPlayersVolumeFilterProp_3.value * 2
        remixPlayersFilterProp_3.value = 0.5
        remixPlayersFilterOnProp_3.value = false
      }
      else {
        remixPlayersVolumeProp_3.value = 1.0
        remixPlayersFilterProp_3.value = 0.5
        remixPlayersFilterOnProp_3.value = false
      }
    }
  }

  MappingPropertyDescriptor {
    id: remixPlayersVolumeFilterProp_4
    path: "mapping.state." + module.deckIdx + ".remix_players_4_volume_filter"
    type: MappingPropertyDescriptor.Float
    value: 0.5
    min: 0.0
    max: 1.0
    onValueChanged: {
      remixPlayersVolumeFilterUpdateTimer_4.restart() // This alignes Superknob parameter with ascociated sub parameters
    }
  }

  Timer {
    id: remixPlayersVolumeFilterUpdateTimer_4
    interval: 10
    repeat: false
    triggeredOnStart: true
    onTriggered: {
      if (remixPlayersVolumeFilterProp_4.value > 0.5) {
        remixPlayersVolumeProp_4.value = 1.0
        remixPlayersFilterProp_4.value = remixPlayersVolumeFilterProp_4.value
        remixPlayersFilterOnProp_4.value = true
      }
      else if (remixPlayersVolumeFilterProp_4.value < 0.5) {
        remixPlayersVolumeProp_4.value = remixPlayersVolumeFilterProp_4.value * 2
        remixPlayersFilterProp_4.value = 0.5
        remixPlayersFilterOnProp_4.value = false
      }
      else {
        remixPlayersVolumeProp_4.value = 1.0
        remixPlayersFilterProp_4.value = 0.5
        remixPlayersFilterOnProp_4.value = false
      }
    }
  }

  AppProperty { id: stableTempoProp; path: "app.traktor.decks." + module.deckIdx + ".tempo.true_tempo" }
  AppProperty { id: tempoBendDiscreteProp; path: "app.traktor.decks." + module.deckIdx + ".tempobend.discrete" }
  AppProperty { id: tempoBendSteplessProp; path: "app.traktor.decks." + module.deckIdx + ".tempobend.stepless" }
  AppProperty { id: keyLockProp; path: "app.traktor.decks." + module.deckIdx + ".track.key.lock_enabled" }
  AppProperty { id: keyAdjustProp; path: "app.traktor.decks." + module.deckIdx + ".track.key.adjust" }

  // property bool previousKeyLockState: false
  // property bool previousSyncState: false
  MappingPropertyDescriptor { id: vinylBreakProp; path: propertiesPath + ".vinyl_break"; type: MappingPropertyDescriptor.Boolean; value: false; }
  MappingPropertyDescriptor { id: previousKeyLockState; path: propertiesPath + ".previous_keylock_state"; type: MappingPropertyDescriptor.Boolean; value: false; }
  MappingPropertyDescriptor { id: previousSyncState; path: propertiesPath + ".previous_sync_state"; type: MappingPropertyDescriptor.Boolean; value: false; }
  
  // AppProperty { id: deckPlayingProp; path: "app.traktor.decks." + module.deckIdx + ".play"; }
  AppProperty { id: deckPlayingProp; path: "app.traktor.decks." + module.deckIdx + ".play";
    onValueChanged: {
      if (value) {
        vinylBreakProp.value = false
        tempoBendSteplessProp.value = 0
        resetSyncKeylock()
      }
    }
  }
  AppProperty { id: deckCueingProp; path: "app.traktor.decks." + module.deckIdx + ".cue"; }
  AppProperty { id: deckRunningProp; path: "app.traktor.decks." + module.deckIdx + ".running" }
  AppProperty { id: deckSeekProp; path: "app.traktor.decks." + module.deckIdx + ".seek" }
  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + module.deckIdx + ".type"; }

  AppProperty { id: activeCueTypeProp; path: "app.traktor.decks." + module.deckIdx + ".track.cue.active.type" }
  AppProperty { id: loopActiveProp; path: "app.traktor.decks." + module.deckIdx + ".loop.active" }

  AppProperty { id: deckIsLoaded; path: "app.traktor.decks." + module.deckIdx + ".is_loaded" }

  AppProperty { path: "app.traktor.decks." + module.deckIdx + ".is_loaded_signal";
    onValueChanged: {
      vinylBreakProp.value = false
      tempoBendSteplessProp.value = 0
      resetSyncKeylock()
      loadResetTimer.restart()
      if (minimizeBrowserWhenLoadingProp.value) {
        browserModeProp.value = false
      }
    }
  }
  
  function disableSyncKeylock() {
    if (syncProp.value) {
      previousSyncState.value = true
      syncProp.value = false
    }
    else previousSyncState.value = false
    if (Math.abs(keyAdjustProp.value) <= 0.05/12 && keyLockProp.value) {
      previousKeyLockState.value = true
      keyLockProp.value = false
    }
    else previousKeyLockState.value = false
  }
  
  function resetSyncKeylock() {
    if (previousKeyLockState.value) {
      keyLockProp.value = true
      previousKeyLockState.value = false
    }
    if (previousSyncState.value) {
      isSyncTriggeredProp.value = !isSyncTriggeredProp.value // syncProp.value = true
      previousSyncState.value = false
    }
  }

  Timer {
    id: loadResetTimer
    interval: 400
    repeat: false
    onTriggered: {
      if (deckTypeProp.value == DeckType.Stem) {
        stemVolumeProp_1.value = 1.0
        stemVolumeProp_2.value = 1.0
        stemVolumeProp_3.value = 1.0
        stemVolumeProp_4.value = 1.0
        stemMutedProp_1.value = false
        stemMutedProp_2.value = false
        stemMutedProp_3.value = false
        stemMutedProp_4.value = false
        stemFilterProp_1.value = 0.5
        stemFilterProp_2.value = 0.5
        stemFilterProp_3.value = 0.5
        stemFilterProp_4.value = 0.5
        stemFilterOnProp_1.value = false
        stemFilterOnProp_2.value = false
        stemFilterOnProp_3.value = false
        stemFilterOnProp_4.value = false
        stemFxSendProp_1.value = 1.0
        stemFxSendProp_2.value = 1.0
        stemFxSendProp_3.value = 1.0
        stemFxSendProp_4.value = 1.0
        stemFxSendOnProp_1.value = true
        stemFxSendOnProp_2.value = true
        stemFxSendOnProp_3.value = true
        stemFxSendOnProp_4.value = true
        stemVolumeFilterProp_1.value = 0.5
        stemVolumeFilterProp_2.value = 0.5
        stemVolumeFilterProp_3.value = 0.5
        stemVolumeFilterProp_4.value = 0.5
      }
      else if (deckTypeProp.value == DeckType.Remix) {
        remixPlayersVolumeProp_1.value = 1.0
        remixPlayersVolumeProp_2.value = 1.0
        remixPlayersVolumeProp_3.value = 1.0
        remixPlayersVolumeProp_4.value = 1.0
        remixPlayersMutedProp_1.value = false
        remixPlayersMutedProp_2.value = false
        remixPlayersMutedProp_3.value = false
        remixPlayersMutedProp_4.value = false
        remixPlayersFilterProp_1.value = 0.5
        remixPlayersFilterProp_2.value = 0.5
        remixPlayersFilterProp_3.value = 0.5
        remixPlayersFilterProp_4.value = 0.5
        remixPlayersFilterOnProp_1.value = false
        remixPlayersFilterOnProp_2.value = false
        remixPlayersFilterOnProp_3.value = false
        remixPlayersFilterOnProp_4.value = false
        remixPlayersFxSendProp_1.value = 1.0
        remixPlayersFxSendProp_2.value = 1.0
        remixPlayersFxSendProp_3.value = 1.0
        remixPlayersFxSendProp_4.value = 1.0
        remixPlayersFxSendOnProp_1.value = true
        remixPlayersFxSendOnProp_2.value = true
        remixPlayersFxSendOnProp_3.value = true
        remixPlayersFxSendOnProp_4.value = true
        remixPlayersVolumeFilterProp_1.value = 0.5
        remixPlayersVolumeFilterProp_2.value = 0.5
        remixPlayersVolumeFilterProp_3.value = 0.5
        remixPlayersVolumeFilterProp_4.value = 0.5
      }
    }
  }
  
  // Native Modules
  
  Loop { name: "loop";  channel: module.deckIdx }
  KeyControl { name: "key_control"; channel: module.deckIdx }
  
  Lighter { name: "sync_lighter"; ledCount: 6; color: Color.Red;   brightness: 1.0 }
  Lighter { name: "loop_lighter"; ledCount: 6; color: Color.Green; brightness: 1.0 }
  Blinker { name: "warning_blinker"; ledCount: 6; autorun: true; color: Color.Red; defaultBrightness: 0.0; cycle: 300 }

  Lighter { name: "default_lighter";   ledCount: 6; color: module.bottomLedsDefaultColor; brightness: 1.0 }
  Lighter { name: "rainbow_lighter_1"; color: Color.Red;                     brightness: 1.0 }
  Lighter { name: "rainbow_lighter_2"; color: Color.LightOrange;             brightness: 1.0 }
  Lighter { name: "rainbow_lighter_3"; color: Color.Yellow;                  brightness: 1.0 }
  Lighter { name: "rainbow_lighter_4"; color: Color.Green;                   brightness: 1.0 }
  Lighter { name: "rainbow_lighter_5"; color: Color.Blue;                    brightness: 1.0 }
  Lighter { name: "rainbow_lighter_6"; color: Color.Purple;                  brightness: 1.0 }

  FluxedLoop { name: "fluxed_loop"; channel: module.deckIdx }
  ButtonSection { name: "stutter_pads"; buttons: 6; color: Color.Green; buttonHandling: ButtonSection.Stack }

  StemDeckStreams { name: "stems"; channel: module.deckIdx }

  Browser { name: "browser" }
  ButtonGestures { name: "browser_load_gestures" }

  RemixDeck { name: "remix"; channel: module.deckIdx; size: RemixDeck.Small }

  WiresGroup
  {
    enabled: module.active

    // Wire { from: "%surface%.loop"; to: "loop.autoloop"; enabled: !module.shift && !module.syncModifier }
    // Wire { from: SetPropertyAdapter{ path: "app.traktor.decks." + module.deckIdx + ".loop.active"; value: 1; input: false; color: Color.White } to: "%surface%.loop.indicator" }
    Wire { from: "%surface%.loop"; to: "loop.autoloop"; enabled: !module.shift && !module.syncModifier && !browserModeProp.value }
    Wire { from: SetPropertyAdapter{ path: "app.traktor.decks." + module.deckIdx + ".loop.active"; value: 1; input: false; color: Color.Green } to: "%surface%.loop.indicator" }

    WiresGroup
    {
      // enabled: module.shift
      // enabled: module.shift && !browserModeProp.value
      // enabled: module.shift && !browserModeProp.value && customBrowserModeProp.value
      enabled: module.shift && !browserModeProp.value && customBrowserModeProp.value && (deckTypeProp.value != DeckType.Remix)

      // Wire { from: "%surface%.loop"; to: "loop.move"; enabled: loopShiftAction == beatjump_loop }
      // Wire { from: "%surface%.loop"; to: "key_control.coarse"; enabled: loopShiftAction == key_adjust }
      Wire { from: "%surface%.loop"; to: "key_control.coarse"; }
    }

    WiresGroup
    {
      // enabled: module.shift
      enabled: module.shift && !browserModeProp.value && !customBrowserModeProp.value

      Wire { from: "%surface%.loop"; to: "loop.move"; enabled: loopShiftAction == beatjump_loop }
      // Wire { from: "%surface%.loop"; to: "key_control.coarse"; enabled: (loopShiftAction == key_adjust) }
      Wire { from: "%surface%.loop"; to: "key_control.coarse"; enabled: (loopShiftAction == key_adjust) && (deckTypeProp.value != DeckType.Remix) }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.loop_in_out)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.loop_in_out))

      Wire { from: "%surface%.hotcues.1"; to: "loop.in" }
      Wire { from: "%surface%.hotcues.2"; to: "loop.out" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.loop_in_out)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.loop_in_out))

      Wire { from: "%surface%.hotcues.3"; to: "loop.in" }
      Wire { from: "%surface%.hotcues.4"; to: "loop.out" }
    }
  }
  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.bottom.leds";  to: "loop_lighter"; enabled: shouldShowActiveLoop }
    Wire { from: "%surface%.bottom.leds";  to: "warning_blinker"; enabled: shouldShowEndWarning && !shouldShowActiveLoop }
    Wire { from: "%surface%.bottom.leds";  to: "sync_lighter"; enabled: shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop }

    WiresGroup
    {
      enabled: !shouldShowSyncWarning && !shouldShowEndWarning && !shouldShowActiveLoop

      Wire { from: "%surface%.bottom.leds"; to: "default_lighter"; enabled: module.bottomLedsDefaultColor != Color.White }

      WiresGroup
      {
        enabled: module.bottomLedsDefaultColor == Color.White
    
        Wire { from: "%surface%.bottom.leds.1"; to: "rainbow_lighter_1" }
        Wire { from: "%surface%.bottom.leds.2"; to: "rainbow_lighter_2" }
        Wire { from: "%surface%.bottom.leds.3"; to: "rainbow_lighter_3" }
        Wire { from: "%surface%.bottom.leds.4"; to: "rainbow_lighter_4" }
        Wire { from: "%surface%.bottom.leds.5"; to: "rainbow_lighter_5" }
        Wire { from: "%surface%.bottom.leds.6"; to: "rainbow_lighter_6" }
      }
    }
  }

  WiresGroup
  {
    // enabled: module.active && !module.shift && module.syncModifier
    // enabled: module.active && !module.shift && module.syncModifier && !module.isSlaveDeck && !browserModeProp.value
    enabled: module.active && !module.shift && module.syncModifier  && !browserModeProp.value

    Wire {
      from: "%surface%.loop.turn"
      to: EncoderScriptAdapter {
        onTick: {
          module.resetTempoEngaged = false;
        }
        onIncrement: {
          // tempoAbsProp.value = tempoAbsProp.value + (module.coarseTempoStep ? 0.01 : 0.001)
          if (module.isSlaveDeck) clockBPMProp.value = clockBPMProp.value + (module.coarseTempoStep ? 1 : 0.01)
          else bpmProp.value = bpmProp.value + (module.coarseTempoStep ? 1 : 0.01)
        }
        onDecrement: {
          // tempoAbsProp.value = tempoAbsProp.value - (module.coarseTempoStep ? 0.01 : 0.001)
          if (module.isSlaveDeck) clockBPMProp.value = clockBPMProp.value - (module.coarseTempoStep ? 1 : 0.01)
          else bpmProp.value = bpmProp.value - (module.coarseTempoStep ? 1 : 0.01)
        }
      }
    }

    Wire {
      from: "%surface%.loop.push"
      to: ButtonScriptAdapter {
        onPress: {
          module.coarseTempoStep = true;
          module.resetTempoEngaged = true;
        }
        onRelease: {
          module.coarseTempoStep = false;
          if (module.resetTempoEngaged)
          {
            // Reset the tempo
            if (module.isSlaveDeck) {
              clockBPMProp.value = trackBaseBPMProp.value;
            }
            else tempoAdjProp.value = 0.0
            // tempoAdjProp.value = 0.0
          }
        }
      }
    }
  }

  WiresGroup
  {
    enabled: module.active && module.shift && (deckTypeProp.value == DeckType.Remix) && ((customBrowserModeProp.value && !browserModeProp.value.value) || (!customBrowserModeProp.value && (loopShiftAction == key_adjust)))

    // Wire { from: "%surface%.loop.push";  to: HoldPropertyAdapter  { path: propertiesPath + ".quantize_engaged"; value: true } }
    // Wire { from: "%surface%.loop.push";  to: TogglePropertyAdapter  { path: "app.traktor.decks." + module.deckIdx + ".remix.quant" } }
    Wire {
      from: "%surface%.loop.push"
      to: ButtonScriptAdapter {
        onPress: {
          module.resetQuantizeEngaged = true
          quantizeEngagedProp.value = true
        }
        onRelease: {
          module.quantizeEngaged = false;
          quantizeEngagedProp.value = false
          if (module.resetQuantizeEngaged) {
            remixQuantProp.value = !remixQuantProp.value
            module.resetQuantizeEngaged = false
          }
        }
      }
    }
    
    Wire { from: "%surface%.loop.turn";  to: "remix.capture_source"; enabled: !quantizeEngagedProp.value }
    
    // Wire { from: "%surface%.loop.turn"; to: EncoderScriptAdapter { onTick: { remixQuantProp.value = true } } enabled: quantizeEngagedProp.value }
    Wire {
      enabled: quantizeEngagedProp.value
      from: "%surface%.loop.turn"
      to: EncoderScriptAdapter {
        onTick: {
          module.resetQuantizeEngaged = false;
          remixQuantProp.value = true;
        }
      }
    }

    
    Wire { from: "%surface%.loop.turn";  to: RelativePropertyAdapter { path:"app.traktor.decks." + module.deckIdx + ".remix.quant_index"; mode: RelativeMode.Stepped } enabled: quantizeEngagedProp.value }
  }

  // Absolute/Relative
  SetPropertyAdapter { name: "play_mode_absolute"; path: "app.traktor.decks." + module.deckIdx + ".playback_mode"; color: Color.Blue; value: PlaybackMode.Absolute }
  SetPropertyAdapter { name: "play_mode_relative"; path: "app.traktor.decks." + module.deckIdx + ".playback_mode"; color: Color.Blue; value: PlaybackMode.Relative }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.abs_rel)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.abs_rel))

      Wire { from: "%surface%.hotcues.1"; to: "play_mode_absolute" }
      Wire { from: "%surface%.hotcues.2"; to: "play_mode_relative" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.abs_rel)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.abs_rel))

      Wire { from: "%surface%.hotcues.3"; to: "play_mode_absolute" }
      Wire { from: "%surface%.hotcues.4"; to: "play_mode_relative" }
    }
  }

  // Stutter Loops

  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_32 } to: "stutter_pads.button1.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_16 } to: "stutter_pads.button2.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_8  } to: "stutter_pads.button3.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_4  } to: "stutter_pads.button4.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1_2  } to: "stutter_pads.button5.value" }
  Wire { from: ConstantValue { type: ConstantValue.Integer; value: LoopSize.loop_1    } to: "stutter_pads.button6.value" }

  Wire { from: "stutter_pads.value";      to: "fluxed_loop.size"   }
  Wire { from: "stutter_pads.active";     to: "fluxed_loop.active" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_132_116)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_132_116))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button1" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button2" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_132_116)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_132_116))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button1" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button2" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_18_14)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_18_14))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button3" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button4" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_18_14)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_18_14))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button3" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button4" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_14_12)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_14_12))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button4" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button5" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_14_12)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_14_12))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button4" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button5" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.stutter_12_1)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.stutter_12_1))

      Wire { from: "%surface%.hotcues.1"; to: "stutter_pads.button5" }
      Wire { from: "%surface%.hotcues.2"; to: "stutter_pads.button6" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.stutter_12_1)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.stutter_12_1))

      Wire { from: "%surface%.hotcues.3"; to: "stutter_pads.button5" }
      Wire { from: "%surface%.hotcues.4"; to: "stutter_pads.button6" }
    }
  }

  // Stem controls

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.mute_stems_12)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.mute_stems_12))

      Wire { from: "%surface%.hotcues.1"; to: "stems.1.muted" }
      Wire { from: "%surface%.hotcues.2"; to: "stems.2.muted" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.mute_stems_12)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.mute_stems_12))

      Wire { from: "%surface%.hotcues.3"; to: "stems.1.muted" }
      Wire { from: "%surface%.hotcues.4"; to: "stems.2.muted" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue12PushAction == HotcueAction.mute_stems_34)) || (module.shift && (hotcue12ShiftPushAction == HotcueAction.mute_stems_34))

      Wire { from: "%surface%.hotcues.1"; to: "stems.3.muted" }
      Wire { from: "%surface%.hotcues.2"; to: "stems.4.muted" }
    }

    WiresGroup
    {
      enabled: (!module.shift && (hotcue34PushAction == HotcueAction.mute_stems_34)) || (module.shift && (hotcue34ShiftPushAction == HotcueAction.mute_stems_34))

      Wire { from: "%surface%.hotcues.3"; to: "stems.3.muted" }
      Wire { from: "%surface%.hotcues.4"; to: "stems.4.muted" }
    }
  }

  // FX Assignment

  WiresGroup {
    enabled: module.active

    WiresGroup {
      enabled: (fxSectionLayer == FXSectionLayer.mixer) && ( (deckTypeProp.value == DeckType.Stem) || (deckTypeProp.value == DeckType.Remix) )

      Wire { from: "%surface%.assign.left";  to: SetPropertyAdapter { path: module.fxAssignmentPropertiesPath + ".mixer_stem_overlay_active"; value: false; color: Color.Blue } }
      Wire { from: "%surface%.assign.right";  to: SetPropertyAdapter { path: module.fxAssignmentPropertiesPath + ".mixer_stem_overlay_active"; value: true; color: Color.Blue } }
    }

    WiresGroup {
      enabled: fxMode.value == FxMode.TwoFxUnits && fxSectionLayer != FXSectionLayer.mixer

      WiresGroup {
        enabled: !customFxAssignmentsUnitFocusProp.value
        
        Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } }
        Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } }
      }
      
      WiresGroup {
        enabled: customFxAssignmentsUnitFocusProp.value
          
        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.1"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.2"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.1"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.2"; color: Color.LightOrange } }
        }
      
      }

    }

    WiresGroup {
      enabled: fxMode.value == FxMode.FourFxUnits && fxSectionLayer != FXSectionLayer.mixer

      WiresGroup {
        enabled: !customFxAssignmentsUnitFocusProp.value
          
        WiresGroup {
          enabled: !module.shift

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } enabled: module.leftPrimaryFxIdx == 1 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } enabled: module.leftPrimaryFxIdx == 2 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } enabled: module.leftPrimaryFxIdx == 3 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } enabled: module.leftPrimaryFxIdx == 4 }

          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } enabled: module.rightPrimaryFxIdx == 1 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } enabled: module.rightPrimaryFxIdx == 2 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } enabled: module.rightPrimaryFxIdx == 3 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } enabled: module.rightPrimaryFxIdx == 4 }
        }

        WiresGroup {
          enabled: module.shift

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } enabled: module.leftSecondaryFxIdx == 1 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } enabled: module.leftSecondaryFxIdx == 2 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } enabled: module.leftSecondaryFxIdx == 3 }
          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } enabled: module.leftSecondaryFxIdx == 4 }

          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } enabled: module.rightSecondaryFxIdx == 1 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } enabled: module.rightSecondaryFxIdx == 2 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } enabled: module.rightSecondaryFxIdx == 3 }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } enabled: module.rightSecondaryFxIdx == 4 }
        }
      
        // WiresGroup {
          // enabled: !module.shift

          // Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.1"; color: Color.LightOrange } }
          // Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.2"; color: Color.LightOrange } }
        // }

        // WiresGroup {
          // enabled: module.shift

          // Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.3"; color: Color.LightOrange } }
          // Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.assign.4"; color: Color.LightOrange } }
        // }
      
      }

      WiresGroup {
        enabled: customFxAssignmentsUnitFocusProp.value && fxSectionLayer == FXSectionLayer.fx_primary
          
        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.1"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.2"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 3)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.3"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.3"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sidePrimaryFxIdx == 4)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.4"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.4"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.1"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.2"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 3)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.3"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.3"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sidePrimaryFxIdx == 4)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.4"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.4"; color: Color.LightOrange } }
        }
      
      }
      
      WiresGroup {
        enabled: customFxAssignmentsUnitFocusProp.value && fxSectionLayer == FXSectionLayer.fx_secondary
          
        WiresGroup {
          enabled: !module.shift && (module.sideSecondaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.1"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sideSecondaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.2"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sideSecondaryFxIdx == 3)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.3"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.3"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: !module.shift && (module.sideSecondaryFxIdx == 4)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.assign.4"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.assign.4"; color: Color.LightOrange }  }
        }

        WiresGroup {
          enabled: module.shift && (module.sideSecondaryFxIdx == 1)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.1"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.1"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sideSecondaryFxIdx == 2)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.2"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.2"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sideSecondaryFxIdx == 3)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.3"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.3"; color: Color.LightOrange } }
        }
      
        WiresGroup {
          enabled: module.shift && (module.sideSecondaryFxIdx == 4)

          Wire { from: "%surface%.assign.left";  to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.assign.4"; color: Color.LightOrange } }
          Wire { from: "%surface%.assign.right"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.assign.4"; color: Color.LightOrange } }
        }
      
      }
      
    }
    
  }

  ButtonScriptAdapter {
    name: "LoadButton"
    onPress: {
      holdLoad_countdown.restart()
    }
    onRelease: {
      if (holdLoad_countdown.running) {
        holdLoad_countdown.stop()
        loadPrimary.value = true
      }
    }
  }
  
  Timer { id: holdLoad_countdown; interval: 250
    onTriggered: {
      loadSecondary.value = true
    }
  }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      // enabled: !browserModeProp.value
      enabled: !browserModeProp.value && customBrowserModeProp.value

      Wire { enabled: !module.shift; from: "%surface%.browse"; to: "loop.move" }
      // Wire { enabled: module.shift; from: "%surface%.browse"; to: "loop.one_beat_move"; }
      WiresGroup {
        enabled:  module.shift
        Wire { from: "%surface%.browse.is_turned"; to: SetPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".move.size"; value: 6 } } // Move Size = 1 Beat
        Wire { from: "%surface%.browse.is_turned"; to: SetPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".move.mode"; value: 0 } enabled: !loopActiveProp.value || ( activeCueTypeProp.value != 5 ) } // Move
        Wire { from: "%surface%.browse.is_turned"; to: SetPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".move.mode"; value: 1 } enabled: loopActiveProp.value && ( activeCueTypeProp.value == 5 ) } // Move Loop
        Wire { from: "%surface%.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".move_internal"; step: 1; mode: RelativeMode.Stepped } }
        Wire { from: "%surface%.browse.push";   to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".cup"; output: false } }
        Wire { from: "%surface%.browse.push";   to: SetPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".loop.active"; value: true; output: false } enabled: ( activeCueTypeProp.value == 5 ) }
      }
    }

    WiresGroup
    {
      // enabled: !browserModeProp.value
      enabled: !browserModeProp.value && !customBrowserModeProp.value

      WiresGroup
      {
        enabled: !module.shift
        
        Wire { from: "%surface%.browse.push"; to: "LoadButton" }
        Wire { from: "%surface%.browse"; to: "browser.list_navigation" }
      }
      
      WiresGroup
      {
        enabled: module.shift

        Wire
        {
          from: "%surface%.browse.turn"
          to: "browser.favorites_navigation.turn"
          enabled: browseShiftAction == BrowseEncoderAction.browse_favorites
        }

        Wire
        {
          from: "%surface%.browse"
          to: "browser.tree_navigation"
          enabled: browseShiftAction == BrowseEncoderAction.browse_tree
        }

        Wire
        {
          from: "%surface%.browse.push"
          to: "browser.tree_navigation.push"
          enabled: browseShiftPushAction == BrowseEncoderAction.browse_expand_tree
        }

        Wire
        {
          from: "%surface%.browse.push"
          to: "browser.full_screen"
          enabled: browseShiftPushAction == BrowseEncoderAction.browse_toggle_full_screen
        }
      }

    }

    WiresGroup
    {
      enabled: browserModeProp.value

      Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.browser.preview_player.unload" } }
      // Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load.selected" } }
      Wire { from: "%surface%.browse.push"; to: "LoadButton" }
      // Wire { from: "%surface%.browse.push"; to: "browser_load_gestures.input" }
      // Wire { from: "browser_load_gestures.single_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load.selected"; output: false } }
      // Wire { from: "browser_load_gestures.double_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load_secondary.selected"; output: false } }
      // Wire { from: "browser_load_gestures.long_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load_stems.selected"; output: false } }
      // Wire { from: "browser_load_gestures.long_click"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load_secondary.selected"; output: false } }
    }

    // WiresGroup
    // {
      // enabled: !module.shift

      // Wire { from: "%surface%.browse"; to: "browser.list_navigation" }
      // Wire { from: "%surface%.browse.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + module.deckIdx + ".load.selected" } }
    // }

    // WiresGroup
    // {
      // enabled: module.shift

      // Wire
      // {
        // from: "%surface%.browse.turn"
        // to: "browser.favorites_navigation.turn"
        // enabled: browseShiftAction == BrowseEncoderAction.browse_favorites
      // }

      // Wire
      // {
        // from: "%surface%.browse"
        // to: "browser.tree_navigation"
        // enabled: browseShiftAction == BrowseEncoderAction.browse_tree
      // }

      // Wire
      // {
        // from: "%surface%.browse.push"
        // to: "browser.tree_navigation.push"
        // enabled: browseShiftPushAction == BrowseEncoderAction.browse_expand_tree
      // }

      // Wire
      // {
        // from: "%surface%.browse.push"
        // to: "browser.full_screen"
        // enabled: browseShiftPushAction == BrowseEncoderAction.browse_toggle_full_screen
      // }
    // }
    
  }
  
  //------------------------SUBMODULES----------------------------

  X1MK3TransportButtons
  {
    name: "transport"
    shift: module.shift
    active: module.active
    surface: module.surface
    deckIdx: module.deckIdx

    nudgePushAction: module.nudgePushAction
    nudgeShiftPushAction: module.nudgeShiftPushAction
  }

  X1MK3HotcueButtons
  {
    name: "hotcue"
    shift: module.shift
    active: module.active
    surface: module.surface
    deckIdx: module.deckIdx

    hotcue12PushAction: module.hotcue12PushAction
    hotcue34PushAction: module.hotcue34PushAction
    hotcue12ShiftPushAction: module.hotcue12ShiftPushAction
    hotcue34ShiftPushAction: module.hotcue34ShiftPushAction
  }

}
