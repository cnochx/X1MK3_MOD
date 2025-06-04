import CSI 1.0
import QtQuick 2.5

import "Defines"

Module
{
  id: module
  property string surface: ""
  property string propertiesPath: ""
  property bool shift: false
  property alias state: deviceSetupStateProp.value

  readonly property int leftDeckIdx: DeviceAssignment.leftDeckIdx(deckAssignmentProp.value)
  readonly property int rightDeckIdx: DeviceAssignment.rightDeckIdx(deckAssignmentProp.value)

  readonly property int leftPrimaryFxIdx: DeviceAssignment.leftPrimaryFxIdx(fxAssignmentProp.value)
  readonly property int rightPrimaryFxIdx: DeviceAssignment.rightPrimaryFxIdx(fxAssignmentProp.value)

  readonly property int leftSecondaryFxIdx: DeviceAssignment.leftSecondaryFxIdx(fxAssignmentProp.value)
  readonly property int rightSecondaryFxIdx: DeviceAssignment.rightSecondaryFxIdx(fxAssignmentProp.value)

  function reset()
  {
    deviceSetupStateProp.value = DeviceSetupState.unassigned;
    lastTouchedButtonLeftSideProp.value = 0
    lastTouchedButtonRightSideProp.value = 0
    deviceSetupPageProp.value = 1
    resetOverlayOvermapping()
  }

  function deckswitch()
  {
        switch (deckAssignmentProp.value) {
          case DeviceAssignment.decks_a_b:
            deckAssignmentProp.value = DeviceAssignment.decks_c_d
            if (fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value) {
              fxAssignmentProp.value = DeviceAssignment.fx_3_4
            }
            break;

          case DeviceAssignment.decks_c_d:
            deckAssignmentProp.value = DeviceAssignment.decks_a_b
            if (fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value) {
              fxAssignmentProp.value = DeviceAssignment.fx_1_2
            }
            break;

          case DeviceAssignment.decks_c_a:
            deckAssignmentProp.value = DeviceAssignment.decks_b_d
            if (fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value) {
              fxAssignmentProp.value = DeviceAssignment.fx_2_4
            }
            break;
          case DeviceAssignment.decks_b_d:
            deckAssignmentProp.value = customDeckSwitchAcVariantProp.value ? DeviceAssignment.decks_a_c : DeviceAssignment.decks_c_a
            if (fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value) {
              fxAssignmentProp.value = customDeckSwitchAcVariantProp.value ? DeviceAssignment.fx_1_3 : DeviceAssignment.fx_3_1
            }
            break;
          case DeviceAssignment.decks_a_c:
            deckAssignmentProp.value = DeviceAssignment.decks_b_d
            if (fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value) {
              fxAssignmentProp.value = DeviceAssignment.fx_2_4
            }
            break;
        }
  }

  function resetOverlayOvermapping() {
    if (customOvermappingEngagedProp.value) {
      if (deviceSetupStateProp.value == DeviceSetupState.unassigned) {
        remixPageDeckA.value = 3
        remixPageDeckB.value = 3
      }
      else if (deviceSetupStateProp.value == DeviceSetupState.assigned) {
        if (deckAssignmentProp.value == DeviceAssignment.decks_a_b || deckAssignmentProp.value == DeviceAssignment.decks_c_a || deckAssignmentProp.value == DeviceAssignment.decks_a_c) {
          remixPageDeckB.value = 3
          if (fxSection.layer == FXSectionLayer.fx_primary) remixPageDeckA.value = 0
          else if (fxSection.layer == FXSectionLayer.fx_secondary) remixPageDeckA.value = 1
          else if (fxSection.layer == FXSectionLayer.mixer) remixPageDeckA.value = 2
        }
        else {
          remixPageDeckA.value = 3
          if (fxSection.layer == FXSectionLayer.fx_primary) remixPageDeckB.value = 0
          else if (fxSection.layer == FXSectionLayer.fx_secondary) remixPageDeckB.value = 1
          else if (fxSection.layer == FXSectionLayer.mixer) remixPageDeckB.value = 2
        }
      }
    }
  }
  
  MappingPropertyDescriptor {
    id: deviceSetupStateProp
    type: MappingPropertyDescriptor.Integer
    path: module.propertiesPath + ".device_setup_state"

    value: DeviceSetupState.unassigned
    min: DeviceSetupState.unassigned
    max: DeviceSetupState.assigned
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 0
      lastTouchedButtonRightSideProp.value = 0
      resetOverlayOvermapping()
    }
  }

  MappingPropertyDescriptor {
    id: deviceSetupPageProp
    path: module.propertiesPath + ".device_setup_page"
    type: MappingPropertyDescriptor.Integer
    value: 1
    min: 1
    max: 2
    onValueChanged: {
      lastTouchedButtonLeftSideProp.value = 0
      lastTouchedButtonRightSideProp.value = 0
    }
  }

  RelativePropertyAdapter { name: "deck_selector"; path: deckAssignmentProp.path; mode: RelativeMode.Stepped; wrap: true }
  RelativePropertyAdapter { name: "fx_selection_prev"; path: fxAssignmentProp.path; mode: RelativeMode.Decrement; wrap: true }
  RelativePropertyAdapter { name: "fx_selection_next"; path: fxAssignmentProp.path; mode: RelativeMode.Increment; wrap: true }
  RelativePropertyAdapter { name: "deck_selection_prev"; path: deckAssignmentProp.path; mode: RelativeMode.Decrement; wrap: true }
  RelativePropertyAdapter { name: "deck_selection_next"; path: deckAssignmentProp.path; mode: RelativeMode.Increment; wrap: true }

  Timer {
    id: deviceSetupCompleted;
    // interval: 1000;
    interval: 500;
    onTriggered:
    {
      // Device has finally been assigned!
      deviceSetupStateProp.value = DeviceSetupState.assigned;
    }
  }

  Timer {
    id: deviceSetupExitTimer;
    interval: 1000;
    onTriggered: {
      deviceSetupStateProp.value = DeviceSetupState.just_assigned;
      deviceSetupCompleted.restart();
    }
  }
  
  ButtonScriptAdapter {
    name: "complete_device_setup";
    onPress: {
      // Decks have been assigned, temporarily go into just_assigned state
      deviceSetupStateProp.value = DeviceSetupState.just_assigned;
      deviceSetupCompleted.restart();
    }
  }

  WiresGroup
  {
    enabled: module.state == DeviceSetupState.unassigned

    Wire { from: "%surface%.left.loop"; to: "deck_selector" }
    Wire { from: "%surface%.left.loop.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.left.browse"; to: "deck_selector" }
    Wire { from: "%surface%.left.browse.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.right.loop"; to: "deck_selector" }
    Wire { from: "%surface%.right.loop.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.right.browse"; to: "deck_selector" }
    Wire { from: "%surface%.right.browse.push"; to: "complete_device_setup" }
    
    // Wire { from: "%surface%.mode"; to: "complete_device_setup" }
    Wire {
      from: "%surface%.mode"
      to: ButtonScriptAdapter {
        onPress: {
          deviceSetupExitTimer.restart()
        }
        onRelease: {
          if (deviceSetupExitTimer.running) {
            deviceSetupExitTimer.stop()
            deviceSetupPageProp.value = (deviceSetupPageProp.value == 1) ? deviceSetupPageProp.value = 2 : deviceSetupPageProp.value = 1
          }
        }
      }
    }

    WiresGroup {
      // enabled: fxModeSetup.value != FxMode.TwoFxUnits && !customLinkFXOverlayToDeckProp.value
      enabled: fxMode.value != FxMode.TwoFxUnits && !customLinkFXOverlayToDeckProp.value
      Wire { from: "%surface%.left.assign.left";   to: "fx_selection_prev" }
      Wire { from: "%surface%.left.assign.right";  to: "fx_selection_next" }
      Wire { from: "%surface%.right.assign.left";  to: "fx_selection_prev" }
      Wire { from: "%surface%.right.assign.right"; to: "fx_selection_next" }
    }

    WiresGroup {
      // enabled: fxModeSetup.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value
      enabled: fxMode.value != FxMode.TwoFxUnits && customLinkFXOverlayToDeckProp.value
      Wire { from: "%surface%.left.assign.left";   to: "deck_selection_prev" }
      Wire { from: "%surface%.left.assign.right";  to: "deck_selection_next" }
      Wire { from: "%surface%.right.assign.left";  to: "deck_selection_prev" }
      Wire { from: "%surface%.right.assign.right"; to: "deck_selection_next" }
    }

    // Wire { enabled: !shift; from: "%surface%.left.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_deck_switch_on_single_click";  color: Color.Yellow } }
    
    // Wire { enabled: !shift && !customMixerOverlayBlockProp.value; from: "%surface%.left.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_mid_low";  color: Color.WarmYellow } }
    // Wire { enabled: shift && !customMixerOverlayBlockProp.value && customMixerMidLowProp.value; from: "%surface%.left.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_low_on_shift"; color: Color.LightOrange } }
    
    // Wire { enabled: !shift && !customMixerOverlayBlockProp.value; from: "%surface%.left.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_volume_on_shift";  color: Color.DarkOrange } }
    
    // Wire { enabled: !shift; from: "%surface%.left.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_single_cue_monitor";  color: Color.Blue } }
    // Wire { enabled: shift; from: "%surface%.left.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_overlay_block";  color: Color.Red } }
    
    // Wire { enabled: !shift; from: "%surface%.right.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_browser_mode"; color: Color.White } }
    // Wire { enabled: shift; from: "%surface%.right.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.maximize_browser_when_browsing"; color: Color.White } }
    
    // Wire { enabled: !shift; from: "%surface%.right.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_fx_assignments_unit_focus";  color: Color.Cyan } }
    
    // Wire { enabled: !shift && fxMode.value != FxMode.TwoFxUnits; from: "%surface%.right.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.custom_link_fx_overlay_to_deck";  color: Color.Turquoise } }
    // Wire { enabled: shift && (fxMode.value != FxMode.TwoFxUnits) && !customLinkFXOverlayToDeckProp.value; from: "%surface%.right.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.custom_secondary_fx_overlay_block";  color: Color.Blue } }
    
    // Wire { enabled: !shift; from: "%surface%.right.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_overmapping_engaged";  color: Color.Purple } }
    
    WiresGroup {
      enabled: (deviceSetupPageProp.value == 1)
      
      Wire { from: "%surface%.left.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_deck_switch_on_single_click";  color: Color.WarmYellow } }
      
      Wire { from: "%surface%.left.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_browser_mode"; color: Color.White } }

      Wire { from: "%surface%.left.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.maximize_browser_when_browsing"; color: Color.White } }

      Wire { from: "%surface%.left.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.minimize_browser_when_loading"; color: Color.White } }
      
      Wire { from: "%surface%.right.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_beatcounter_engaged"; color: Color.Blue } }
      
      Wire { from: "%surface%.right.fx.buttons.2"; to: RelativePropertyAdapter { path: "mapping.settings.custom_phrase_length"; mode: RelativeMode.Decrement; wrap: false; color: Color.Turquoise } }

      Wire { from: "%surface%.right.fx.buttons.3"; to: RelativePropertyAdapter { path: "mapping.settings.custom_phrase_length"; mode: RelativeMode.Increment; wrap: false; color: Color.Turquoise } }

      Wire { from: "%surface%.right.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_overmapping_engaged"; color: Color.Purple } }
    }
    
    WiresGroup {
      enabled: (deviceSetupPageProp.value == 2)
      
      Wire { enabled: !customMixerOverlayBlockProp.value; from: "%surface%.left.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_mid_low";  color: Color.DarkOrange } }
      
      Wire { enabled: !customMixerOverlayBlockProp.value && customMixerMidLowProp.value; from: "%surface%.left.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_low_on_shift"; color: Color.DarkOrange } }
      
      Wire { enabled: !customMixerOverlayBlockProp.value; from: "%surface%.left.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_volume_on_shift";  color: Color.LightOrange } }
      
      Wire { from: "%surface%.left.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_single_cue_monitor";  color: Color.WarmYellow } }
      
      Wire { from: "%surface%.right.fx.buttons.1"; to: TogglePropertyAdapter { path: "mapping.settings.custom_mixer_overlay_block";  color: Color.Red } }
      
      
      Wire { from: "%surface%.right.fx.buttons.2"; to: TogglePropertyAdapter { path: "mapping.settings.custom_fx_assignments_unit_focus";  color: Color.Cyan } }
      
      Wire { enabled: fxMode.value != FxMode.TwoFxUnits; from: "%surface%.right.fx.buttons.3"; to: TogglePropertyAdapter { path: "mapping.settings.custom_link_fx_overlay_to_deck";  color: Color.Cyan } }
      
      Wire { enabled: (fxMode.value != FxMode.TwoFxUnits) && !customLinkFXOverlayToDeckProp.value; from: "%surface%.right.fx.buttons.4"; to: TogglePropertyAdapter { path: "mapping.settings.custom_secondary_fx_overlay_block";  color: Color.Turquoise } }
    }
    
  }
  
}
