import CSI 1.0
import QtQuick 2.0

import "Defines"

Mapping
{
  id: mapping
  readonly property string propertiesPath: "mapping.state"
  // readonly property string settingsPath: "mapping.settings"

  X1MK3 { name: "surface" }

  X1MK3DeviceSetup {
    id: deviceSetup;
    name: "device_setup";

    surface: "surface";
    propertiesPath: mapping.propertiesPath
    shift: shiftProp.value
    // settingsPath: mapping.settingsPath
  }

  onRunningChanged:
  {
    // When the mapping is reloaded go back into device setup
    deviceSetup.reset();
    deviceSetup.resetOverlayOvermapping();
  }

  KontrolScreen { name: "screen"; side: ScreenSide.Left; propertiesPath: mapping.propertiesPath; flavor: ScreenFlavor.X1MK3_Mode }
  Wire { from: "screen.output"; to: "surface.display.mode" }

  // Custom Settings
  MappingPropertyDescriptor { id: lastTouchedButtonLeftSideProp; path: "mapping.state.left.fx.last_active_button"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { id: lastTouchedButtonRightSideProp; path: "mapping.state.right.fx.last_active_button"; type: MappingPropertyDescriptor.Integer; value: 0 }

  MappingPropertyDescriptor {
    id: deckAssignmentProp
    path: "mapping.settings.deck_assignment"
    type: MappingPropertyDescriptor.Integer
    value: DeviceAssignment.decks_a_b
    min: DeviceAssignment.decks_a_b
    max: DeviceAssignment.decks_a_c
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 0
      lastTouchedButtonRightSideProp.value = 0
      if (value == DeviceAssignment.decks_a_b) customDeckSwitchAcVariantProp.value = false
      else if (value == DeviceAssignment.decks_c_d) customDeckSwitchAcVariantProp.value = false
      else if (value == DeviceAssignment.decks_c_a) customDeckSwitchAcVariantProp.value = false
      else if (value == DeviceAssignment.decks_a_c) customDeckSwitchAcVariantProp.value = true

      if (fxMode.value == FxMode.TwoFxUnits) fxAssignmentProp.value = DeviceAssignment.fx_1_2
      else if (customLinkFXOverlayToDeckProp.value) fxAssignmentProp.value = value

      deviceSetup.resetOverlayOvermapping()
    }
  }

  MappingPropertyDescriptor {
    id: fxAssignmentProp
    path: "mapping.settings.fx_assignment"
    type: MappingPropertyDescriptor.Integer
    value: DeviceAssignment.fx_1_2
    min: DeviceAssignment.fx_1_2
    max: DeviceAssignment.fx_1_3
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 0
      lastTouchedButtonRightSideProp.value = 0
      deviceSetup.resetOverlayOvermapping()
    }
  }

  MappingPropertyDescriptor {
    id: customDeckSwitchAcVariantProp
    path: "mapping.settings.custom_deck_switch_ac_variant"
    type: MappingPropertyDescriptor.Boolean
    value: false
  }

  // MappingPropertyDescriptor {
    // id: customDeckSwitchOnSingleClickProp
    // path: "mapping.settings.custom_deck_switch_on_single_click"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 1
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customMixerMidLowProp
    // path: "mapping.settings.custom_mixer_mid_low"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 2
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customMixerLowOnShiftProp
    // path: "mapping.settings.custom_mixer_low_on_shift"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 6
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customMixerVolumeOnShiftProp
    // path: "mapping.settings.custom_mixer_volume_on_shift"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 3
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customSingleCueMonitorProp
    // path: "mapping.settings.custom_single_cue_monitor"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 4
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customMixerOverlayBlockProp
    // path: "mapping.settings.custom_mixer_overlay_block"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonLeftSideProp.value = 8
      // if (fx_section.layer == FXSectionLayer.mixer) {
        // fx_section.layer = FXSectionLayer.fx_primary
      // }
    // }
  // }

  // MappingPropertyDescriptor {
    // id: customBrowserModeProp
    // path: "mapping.settings.custom_browser_mode"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 1
    // }
  // }
  // MappingPropertyDescriptor {
    // id: maximizeBrowserWhenBrowsingProp
    // path: "mapping.settings.maximize_browser_when_browsing"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 5
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customFxAssignmentsUnitFocusProp
    // path: "mapping.settings.custom_fx_assignments_unit_focus"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 2
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customLinkFXOverlayToDeckProp
    // path: "mapping.settings.custom_link_fx_overlay_to_deck"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 3
      // if (value == true) {
        // if (fxMode.value == FxMode.TwoFxUnits) {
          // fxAssignmentProp.value = DeviceAssignment.fx_1_2
        // }
        // else if (fxAssignmentProp.value != deckAssignmentProp.value) fxAssignmentProp.value = deckAssignmentProp.value
        // if (fx_section.layer == FXSectionLayer.fx_secondary) {
          // fx_section.layer = FXSectionLayer.fx_primary
        // }
      // }
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customSecondaryFXOverlayBlockProp
    // path: "mapping.settings.custom_secondary_fx_overlay_block"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 7
      // if (fx_section.layer == FXSectionLayer.fx_secondary) {
        // fx_section.layer = FXSectionLayer.fx_primary
      // }
    // }
  // }
  // MappingPropertyDescriptor {
    // id: customOvermappingEngagedProp
    // path: "mapping.settings.custom_overmapping_engaged"
    // type: MappingPropertyDescriptor.Boolean
    // value: false
    // onValueChanged: {
      // lastTouchedButtonRightSideProp.value = 4
      // if (value) {
        // remixPageDeckA.value = 3
        // remixPageDeckB.value = 3
      // }
      // else {
        // remixPageDeckA.value = 0
        // remixPageDeckB.value = 0
      // }
    // }
  // }

  // DECK SWITCH

  MappingPropertyDescriptor {
    id: customDeckSwitchOnSingleClickProp
    path: "mapping.settings.custom_deck_switch_on_single_click"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 1
    }
  }
  
  
  // BROWSER

  MappingPropertyDescriptor {
    id: customBrowserModeProp
    path: "mapping.settings.custom_browser_mode"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 2
    }
  }
  MappingPropertyDescriptor {
    id: maximizeBrowserWhenBrowsingProp
    path: "mapping.settings.maximize_browser_when_browsing"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 3
    }
  }
  MappingPropertyDescriptor {
    id: minimizeBrowserWhenLoadingProp
    path: "mapping.settings.minimize_browser_when_loading"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 4
    }
  }
  
  
  // BEAT COUNTER
  
  MappingPropertyDescriptor {
    id: customBeatCounterEngagedProp
    path: "mapping.settings.custom_beatcounter_engaged"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 1
    }
  }

  MappingPropertyDescriptor {
    id: customBeatCounterPhraseLengthProp
    path: "mapping.settings.custom_phrase_length"
    type: MappingPropertyDescriptor.Integer
    value: 2 // 1, 2, 4, 8, 16, 32, 64 beats
    min: 0 // off, i.e. 'bars.beats' instead of 'phrases.bars.beats'
    max: 6 // 64 beats
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 2 // and 3 basically
    }
  }


  // OVERMAPPING
  
  MappingPropertyDescriptor {
    id: customOvermappingEngagedProp
    path: "mapping.settings.custom_overmapping_engaged"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 4
      if (value) {
        remixPageDeckA.value = 3
        remixPageDeckB.value = 3
      }
      else {
        remixPageDeckA.value = 0
        remixPageDeckB.value = 0
      }
    }
  }


  // MIXER

  MappingPropertyDescriptor {
    id: customMixerMidLowProp
    path: "mapping.settings.custom_mixer_mid_low"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 5
    }
  }
  MappingPropertyDescriptor {
    id: customMixerLowOnShiftProp
    path: "mapping.settings.custom_mixer_low_on_shift"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 6
    }
  }
  MappingPropertyDescriptor {
    id: customMixerVolumeOnShiftProp
    path: "mapping.settings.custom_mixer_volume_on_shift"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 7
    }
  }
  MappingPropertyDescriptor {
    id: customSingleCueMonitorProp
    path: "mapping.settings.custom_single_cue_monitor"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 8
    }
  }
  
  MappingPropertyDescriptor {
    id: customMixerOverlayBlockProp
    path: "mapping.settings.custom_mixer_overlay_block"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 5
      if (fx_section.layer == FXSectionLayer.mixer) {
        fx_section.layer = FXSectionLayer.fx_primary
      }
    }
  }

  
  // EFFECTS
  
  MappingPropertyDescriptor {
    id: customFxAssignmentsUnitFocusProp
    path: "mapping.settings.custom_fx_assignments_unit_focus"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 6
    }
  }
  MappingPropertyDescriptor {
    id: customLinkFXOverlayToDeckProp
    path: "mapping.settings.custom_link_fx_overlay_to_deck"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 7
      if (value == true) {
        if (fxMode.value == FxMode.TwoFxUnits) {
          fxAssignmentProp.value = DeviceAssignment.fx_1_2
        }
        else if (fxAssignmentProp.value != deckAssignmentProp.value) fxAssignmentProp.value = deckAssignmentProp.value
        if (fx_section.layer == FXSectionLayer.fx_secondary) {
          fx_section.layer = FXSectionLayer.fx_primary
        }
      }
    }
  }
  MappingPropertyDescriptor {
    id: customSecondaryFXOverlayBlockProp
    path: "mapping.settings.custom_secondary_fx_overlay_block"
    type: MappingPropertyDescriptor.Boolean
    value: false
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 8
      if (fx_section.layer == FXSectionLayer.fx_secondary) {
        fx_section.layer = FXSectionLayer.fx_primary
      }
    }
  }

  AppProperty { id: remixPageDeckA; path: "app.traktor.decks.1.remix.page"; }
  AppProperty { id: remixPageDeckB; path: "app.traktor.decks.2.remix.page"; }
  
  AppProperty { id: clockBPMProp; path: "app.traktor.masterclock.tempo" }

  AppProperty {
    id: cueMonitorChannelProp1;
    path: "app.traktor.mixer.channels.1.cue";
    onValueChanged: {
      if (value & customSingleCueMonitorProp.value) {
        cueMonitorChannelProp2.value = false;
        cueMonitorChannelProp3.value = false;
        cueMonitorChannelProp4.value = false;
      }
    }
  }
  AppProperty {
    id: cueMonitorChannelProp2;
    path: "app.traktor.mixer.channels.2.cue";
    onValueChanged: {
      if (value & customSingleCueMonitorProp.value) {
        cueMonitorChannelProp1.value = false;
        cueMonitorChannelProp3.value = false;
        cueMonitorChannelProp4.value = false;
      }
    }
  }
  AppProperty {
    id: cueMonitorChannelProp3;
    path: "app.traktor.mixer.channels.3.cue";
    onValueChanged: {
      if (value & customSingleCueMonitorProp.value) {
        cueMonitorChannelProp1.value = false;
        cueMonitorChannelProp2.value = false;
        cueMonitorChannelProp4.value = false;
      }
    }
  }
  AppProperty {
    id: cueMonitorChannelProp4;
    path: "app.traktor.mixer.channels.4.cue";
    onValueChanged: {
      if (value & customSingleCueMonitorProp.value) {
        cueMonitorChannelProp1.value = false;
        cueMonitorChannelProp2.value = false;
        cueMonitorChannelProp3.value = false;
      }
    }
  }

  AppProperty { id: fxMode; path: "app.traktor.fx.4fx_units"; onValueChanged: fxModeChanged() }

  function fxModeChanged() {
    if (fxMode.value == FxMode.TwoFxUnits) {
      fxAssignmentProp.value = DeviceAssignment.fx_1_2
      if (fx_section.layer == FXSectionLayer.fx_secondary) {
        fx_section.layer = FXSectionLayer.fx_primary
      }
    }
    else if (customLinkFXOverlayToDeckProp.value) {
      fxAssignmentProp.value = deckAssignmentProp.value
    }
  }
  
  // Settings
  MappingPropertyDescriptor { path: "mapping.settings.nudge_push_size"; type: MappingPropertyDescriptor.Integer; value: 11 /* 32 beats */ }
  MappingPropertyDescriptor { path: "mapping.settings.nudge_shiftpush_size"; type: MappingPropertyDescriptor.Integer; value: 11 /* 32 beats */ }
  MappingPropertyDescriptor { id: nudgePushActionProp; path: "mapping.settings.nudge_push_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Tempo Bend */ }
  MappingPropertyDescriptor { id: nudgeShiftPushActionProp; path: "mapping.settings.nudge_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 1 /* Beatjump */ }
  
  MappingPropertyDescriptor { id: hotcue12PushActionProp; path: "mapping.settings.hotcue12_push_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Hotcues 1-2 */ }
  MappingPropertyDescriptor { id: hotcue34PushActionProp; path: "mapping.settings.hotcue34_push_action"; type: MappingPropertyDescriptor.Integer; value: 1 /* Hotcues 3-4 */ }
  MappingPropertyDescriptor { id: hotcue12ShiftPushActionProp; path: "mapping.settings.hotcue12_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 4 /* Delete Hotcues 1-2 */ }
  MappingPropertyDescriptor { id: hotcue34ShiftPushActionProp; path: "mapping.settings.hotcue34_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 5 /* Delete Hotcues 3-4 */ }

  MappingPropertyDescriptor { id: browseShiftActionProp; path: "mapping.settings.browse_shift_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Tree Up/Down */ }
  MappingPropertyDescriptor { id: browseShiftPushActionProp; path: "mapping.settings.browse_shiftpush_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Expand/Collapse tree folders */ }

  MappingPropertyDescriptor { id: loopShiftActionProp; path: "mapping.settings.loop_shift_action"; type: MappingPropertyDescriptor.Integer; value: 0 /* Beatjump Loop */ }

  // MappingPropertyDescriptor { id: maximizeBrowserWhenBrowsingProp; path: "mapping.settings.maximize_browser_when_browsing"; type: MappingPropertyDescriptor.Boolean; value: false }

  // MappingPropertyDescriptor { path: "mapping.settings.deck_display.main_info"; type: MappingPropertyDescriptor.Integer; value: 0 /* Remaining Time */ }
  MappingPropertyDescriptor {
    id: deckDisplayMainInfoProp;
    path: "mapping.settings.deck_display.main_info";
    type: MappingPropertyDescriptor.Integer;
    value: 0 /* Remaining Time */
    onValueChanged: {
      lastTouchedButtonRightSideProp.value = 8
    }
  }

  // Color override
  MappingPropertyDescriptor { path: "mapping.settings.12_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.hotcues.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.hotcues.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.12_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.34_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.hotcues.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.hotcues.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.hotcues.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.34_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.nudge_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.nudge_slow.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.nudge_fast.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.nudge_slow.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.nudge_fast.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.nudge_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.cue_rev_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.rev.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.cue.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.rev.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.cue_rev_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.play_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_button.custom_color"; input: false } }
  Wire { from: "surface.right.play.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.play_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.sync_button.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_button.custom_color"; input: false } }
  Wire { from: "surface.right.sync.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.sync_button.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.fx_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.1.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.2.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.3.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.fx.buttons.4.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.fx_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { path: "mapping.settings.assign_buttons.custom_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }
  Wire { from: "surface.left.assign.left.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.left.assign.right.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.assign.left.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }
  Wire { from: "surface.right.assign.right.custom_color"; to: DirectPropertyAdapter { path: "mapping.settings.assign_buttons.custom_color"; input: false } }

  MappingPropertyDescriptor { id: showEndWarningProp; path: "mapping.settings.bottom_leds.show_end_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showSyncWarningProp; path: "mapping.settings.bottom_leds.show_sync_warning"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: showActiveLoopProp; path: "mapping.settings.bottom_leds.show_active_loop"; type: MappingPropertyDescriptor.Boolean; value: true }
  MappingPropertyDescriptor { id: bottomLedsDefaultColorProp; path: "mapping.settings.bottom_leds.default_color"; type: MappingPropertyDescriptor.Integer; value: Color.Black }

  MappingPropertyDescriptor { id: leftDeckIdxProp; path: "mapping.settings.left_deck_index"; type: MappingPropertyDescriptor.Integer; value: deviceSetup.leftDeckIdx }
  MappingPropertyDescriptor { id: rightDeckIdxProp; path: "mapping.settings.right_deck_index"; type: MappingPropertyDescriptor.Integer; value: deviceSetup.rightDeckIdx }

  // Shift
  property alias shift: shiftProp
  MappingPropertyDescriptor { id: shiftProp; path: mapping.propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  // Wire { from: "surface.shift";  to: DirectPropertyAdapter { path: mapping.propertiesPath + ".shift"  } }

  Browser { name: "browser" }

  AppProperty { id: previewplayerUnloadProp; path:"app.traktor.browser.preview_player.unload" }
  AppProperty { id: previewplayerPlayProp; path:"app.traktor.browser.preview_player.play" }
  
  Timer {
    id: shiftBlinkTimer
    property bool  blink: false
    interval: 250
    repeat: true
    running: browserModeProp.value
    onTriggered: {
      blink = !blink;
    }
    onRunningChanged: {
      blink = running;
    }
  }

  Wire {
    from: "surface.shift"
    to: ButtonScriptAdapter {
      brightness: shiftProp.value || shiftBlinkTimer.blink ? 1.0 : 0.0; 
      onPress: {
        shiftProp.value = true;
        holdShift_countdown.restart()
      }
      onRelease: {
        shiftProp.value = false;
        // if ( (holdShift_countdown.running) && (deviceSetup.state == DeviceSetupState.assigned) ) {
        if ( (holdShift_countdown.running) && (deviceSetup.state == DeviceSetupState.assigned) && customBrowserModeProp.value ) {
          browserModeProp.value = !browserModeProp.value
          previewplayerPlayProp.value = false
          // holdShift_countdown.stop()
        }
      }
    }
  }
  
  Timer {
    id: holdShift_countdown;
    interval: 200
    onTriggered: {
      if (!browserModeProp.value) previewplayerUnloadProp.value = !previewplayerUnloadProp.value      
    }
  }
    
  WiresGroup {
    enabled: (deviceSetup.state == DeviceSetupState.assigned) && browserModeProp.value
    
    WiresGroup {
      
      Wire { enabled: !shiftProp.value; from: "surface.left.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.list.select_up_down"; wrap: true; step: 1; mode: RelativeMode.Stepped } }
      Wire { enabled: shiftProp.value; from: "surface.left.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.list.select_up_down"; wrap: true; step: 10; mode: RelativeMode.Stepped } }
      Wire { enabled: !shiftProp.value; from: "surface.right.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.list.select_up_down"; wrap: true; step: 1; mode: RelativeMode.Stepped } }
      Wire { enabled: shiftProp.value; from: "surface.right.browse.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.list.select_up_down"; wrap: true; step: 10; mode: RelativeMode.Stepped } }
      Wire { enabled: !shiftProp.value; from: "surface.right.loop.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.preview_player.seek"; step: 0.05; mode: RelativeMode.Stepped } }
      Wire { enabled: shiftProp.value; from: "surface.right.loop.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.favorites.select"; wrap: true; step: 1; mode: RelativeMode.Stepped } }
        
    }
      
    WiresGroup {
      
      Wire { from: "surface.left.loop"; to: "browser.tree_navigation" }
      Wire { enabled: shiftProp.value; from: "surface.left.loop.turn"; to: RelativePropertyAdapter { path: "app.traktor.browser.tree.select_up_down"; wrap: true; step: 9; mode: RelativeMode.Stepped } }
      Wire { enabled: !shiftProp.value; from: "surface.right.loop.push"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preview_player.load_or_play" } }
      Wire { enabled: shiftProp.value; from: "surface.right.loop.push"; to: TriggerPropertyAdapter { path:"app.traktor.browser.preparation.jump_to_list" } }
        
    }
      
  }

  X1MK3Side
  {
    name: "left_deck"
    surface: "surface.left"
    propertiesPath: mapping.propertiesPath + ".left.deck"
    active: deviceSetup.state == DeviceSetupState.assigned

    shift: shiftProp.value
    deckIdx: deviceSetup.leftDeckIdx

    fxSectionLayer: fxSection.layer
    leftPrimaryFxIdx: deviceSetup.leftPrimaryFxIdx
    rightPrimaryFxIdx: deviceSetup.rightPrimaryFxIdx
    leftSecondaryFxIdx: deviceSetup.leftSecondaryFxIdx
    rightSecondaryFxIdx: deviceSetup.rightSecondaryFxIdx

    fxAssignmentPropertiesPath: mapping.propertiesPath + ".left.fx"
    sidePrimaryFxIdx: deviceSetup.leftPrimaryFxIdx
    sideSecondaryFxIdx: deviceSetup.leftSecondaryFxIdx

    nudgePushAction: nudgePushActionProp.value
    nudgeShiftPushAction: nudgeShiftPushActionProp.value

    hotcue12PushAction: hotcue12PushActionProp.value
    hotcue34PushAction: hotcue34PushActionProp.value
    hotcue12ShiftPushAction: hotcue12ShiftPushActionProp.value
    hotcue34ShiftPushAction: hotcue34ShiftPushActionProp.value

    browseShiftAction: browseShiftActionProp.value
    browseShiftPushAction: browseShiftPushActionProp.value

    loopShiftAction: loopShiftActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  X1MK3Side
  {
    name: "right_deck"
    surface: "surface.right"
    propertiesPath: mapping.propertiesPath + ".right.deck"
    active: deviceSetup.state == DeviceSetupState.assigned

    shift: shiftProp.value
    deckIdx: deviceSetup.rightDeckIdx

    fxSectionLayer: fxSection.layer
    leftPrimaryFxIdx: deviceSetup.leftPrimaryFxIdx
    rightPrimaryFxIdx: deviceSetup.rightPrimaryFxIdx
    leftSecondaryFxIdx: deviceSetup.leftSecondaryFxIdx
    rightSecondaryFxIdx: deviceSetup.rightSecondaryFxIdx

    fxAssignmentPropertiesPath: mapping.propertiesPath + ".right.fx"
    sidePrimaryFxIdx: deviceSetup.rightPrimaryFxIdx
    sideSecondaryFxIdx: deviceSetup.rightSecondaryFxIdx

    nudgePushAction: nudgePushActionProp.value
    nudgeShiftPushAction: nudgeShiftPushActionProp.value

    hotcue12PushAction: hotcue12PushActionProp.value
    hotcue34PushAction: hotcue34PushActionProp.value
    hotcue12ShiftPushAction: hotcue12ShiftPushActionProp.value
    hotcue34ShiftPushAction: hotcue34ShiftPushActionProp.value

    browseShiftAction: browseShiftActionProp.value
    browseShiftPushAction: browseShiftPushActionProp.value

    loopShiftAction: loopShiftActionProp.value

    showEndWarning: showEndWarningProp.value
    showSyncWarning: showSyncWarningProp.value
    showActiveLoop: showActiveLoopProp.value
    bottomLedsDefaultColor: bottomLedsDefaultColorProp.value
  }

  MappingPropertyDescriptor {
    id: browserModeProp;
    path: "mapping.state.browser_mode";
    type: MappingPropertyDescriptor.Boolean;
    value: false;
    onValueChanged: {
      if (maximizeBrowserWhenBrowsingProp.value) browserFullScreenProp.value = value
      // if (customBrowserModeProp.value) browserFullScreenProp.value = value
      // if (customBrowserModeProp.value && maximizeBrowserWhenBrowsingProp.value) browserFullScreenProp.value = value
      previewplayerUnloadProp.value = !previewplayerUnloadProp.value
    }
  }
  
  AppProperty { id: browserFullScreenProp; path: "app.traktor.browser.full_screen" }

  property bool fullScreenTimerRunning: false

  SwitchTimer {
    name: "show_browser_full_screen_timer";
    setTimeout: 0;
    resetTimeout: 2000;

    onSet: {
      fullScreenTimerRunning = true;
      browserFullScreenProp.value = true;
      // browserModeProp.value = true;
    }

    onReset: {
      // browserModeProp.value = false
      browserFullScreenProp.value = false
      fullScreenTimerRunning = false;
    }
  }

  WiresGroup {
    // enabled: (deviceSetup.state == DeviceSetupState.assigned) && maximizeBrowserWhenBrowsingProp.value
    enabled: (deviceSetup.state == DeviceSetupState.assigned) && maximizeBrowserWhenBrowsingProp.value && !customBrowserModeProp.value

    Wire {
      from: Or
      {
        inputs: [ "surface.left.browse.is_turned", "surface.right.browse.is_turned" ]
      }
      to: "show_browser_full_screen_timer.input"
    }

    Wire {
      enabled: shiftProp.value && browseShiftPushActionProp.value == BrowseEncoderAction.browse_expand_tree;
      from: Or
      {
        inputs: [ "surface.left.browse.push", "surface.right.browse.push" ]
      }
      to: "show_browser_full_screen_timer.input"
    }

    Wire {
      enabled: !shiftProp.value && fullScreenTimerRunning && browserModeProp.value;
      from: Or
      {
        inputs: [ "surface.left.browse.push", "surface.right.browse.push" ]
      }
      to: ValuePropertyAdapter { path: "app.traktor.browser.full_screen"; output: false; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled }
    }
  }

  X1MK3FXSection
  {
    id: fxSection
    name: "fx_section"
    surface: "surface"
    shift: shiftProp.value
    propertiesPath: mapping.propertiesPath
    active: deviceSetup.state == DeviceSetupState.assigned

    leftDeckIdx: deviceSetup.leftDeckIdx
    rightDeckIdx: deviceSetup.rightDeckIdx

    leftPrimaryFxIdx: deviceSetup.leftPrimaryFxIdx
    rightPrimaryFxIdx: deviceSetup.rightPrimaryFxIdx
    leftSecondaryFxIdx: deviceSetup.leftSecondaryFxIdx
    rightSecondaryFxIdx: deviceSetup.rightSecondaryFxIdx
  }

  // Blinking timer for screens
  MappingPropertyDescriptor { id: blinkerProp; path: mapping.propertiesPath + ".blinker"; type: MappingPropertyDescriptor.Boolean; value: false }
  Timer { interval: 500; running: true; repeat: true; onTriggered: blinkerProp.value = blinkerProp.value ? false : true; }
} //Mapping
