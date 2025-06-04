import CSI 1.0
import QtQuick 2.0

import "Defines"

Module
{
  id: module
  property bool shift: false
  property bool active: false
  property int layer: 0
  property int deckIdx: 0
  property int primaryUnitIdx: 0
  property int secondaryUnitIdx: 0
  property string surface: ""
  property string propertiesPath: ""

  //------------------------SUBMODULES----------------------------

  MappingPropertyDescriptor { path: module.propertiesPath + ".active_deck"; type: MappingPropertyDescriptor.Integer; value: module.deckIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".primary_fx_unit"; type: MappingPropertyDescriptor.Integer; value: module.primaryUnitIdx }
  MappingPropertyDescriptor { path: module.propertiesPath + ".secondary_fx_unit"; type: MappingPropertyDescriptor.Integer; value: module.secondaryUnitIdx }

  MappingPropertyDescriptor { id: lastActiveKnobProp; path: module.propertiesPath + ".last_active_knob"; type: MappingPropertyDescriptor.Integer; value: 1 }

  // Screen
  KontrolScreen { name: "fx_screen"; propertiesPath: module.propertiesPath; flavor: ScreenFlavor.X1MK3_FX }
  Wire { from: "fx_screen.output"; to: "%surface%.display" }

  MappingPropertyDescriptor { path: module.propertiesPath + ".knobs_are_active"; type: MappingPropertyDescriptor.Boolean; value: false }
  SwitchTimer { name: "knobs_activity_timer"; setTimeout: 0; resetTimeout: 1000 }

  // Knobs activity
  WiresGroup
  {
    enabled: module.active

    Wire {
      from: Or
      {
        inputs:
        [
          "%surface%.buttons.1",
          "%surface%.buttons.2",
          "%surface%.buttons.3",
          "%surface%.buttons.4",
          "%surface%.knobs.1.is_turned",
          "%surface%.knobs.2.is_turned",
          "%surface%.knobs.3.is_turned",
          "%surface%.knobs.4.is_turned"
        ]
      }
      to: "knobs_activity_timer.input"
    }

    Wire { from: "knobs_activity_timer.output.value"; to: ValuePropertyAdapter { path: module.propertiesPath + ".knobs_are_active"; output: false } }

    Wire { from: "%surface%.knobs.1"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 1 } } }
    Wire { from: "%surface%.knobs.2"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 2 } } }
    Wire { from: "%surface%.knobs.3"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 3 } } }
    Wire { from: "%surface%.knobs.4"; to: KnobScriptAdapter { onTurn: { lastActiveKnobProp.value = 4 } } }
  }

  // Soft takeover
  // SoftTakeover { id: sofTakeover01; name: "softtakeover1" }
  // SoftTakeover { id: sofTakeover02; name: "softtakeover2" }
  // SoftTakeover { id: sofTakeover03; name: "softtakeover3" }
  // SoftTakeover { id: sofTakeover04; name: "softtakeover4" }
  SoftTakeover { name: "softtakeover1" }
  SoftTakeover { name: "softtakeover2" }
  SoftTakeover { name: "softtakeover3" }
  SoftTakeover { name: "softtakeover4" }

  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.1.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.2.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.3.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }
  MappingPropertyDescriptor { path: module.propertiesPath + ".softtakeover.4.direction"; type: MappingPropertyDescriptor.Integer; value: 0 }

  WiresGroup
  {
    enabled: module.active

    Wire { from: "%surface%.knobs.1"; to: "softtakeover1.input" }
    Wire { from: "%surface%.knobs.2"; to: "softtakeover2.input" }
    Wire { from: "%surface%.knobs.3"; to: "softtakeover3.input" }
    Wire { from: "%surface%.knobs.4"; to: "softtakeover4.input" }

    Wire { from: "softtakeover1.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.1.direction" } }
    Wire { from: "softtakeover2.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.2.direction" } }
    Wire { from: "softtakeover3.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.3.direction" } }
    Wire { from: "softtakeover4.direction_monitor"; to: DirectPropertyAdapter { path: module.propertiesPath + ".softtakeover.4.direction" } }
  }

  // FX units
  FxUnit { name: "fx_unit_1"; channel: 1 }
  FxUnit { name: "fx_unit_2"; channel: 2 }
  FxUnit { name: "fx_unit_3"; channel: 3 }
  FxUnit { name: "fx_unit_4"; channel: 4 }

  AppProperty { id: fxUnit1Type; path: "app.traktor.fx.1.type" }
  AppProperty { id: fxUnit2Type; path: "app.traktor.fx.2.type" }
  AppProperty { id: fxUnit3Type; path: "app.traktor.fx.3.type" }
  AppProperty { id: fxUnit4Type; path: "app.traktor.fx.4.type" }

  WiresGroup
  {
    enabled: module.active

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 1) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 1)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_1.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_1.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_1.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_1.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_1.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_1.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_1.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_1.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit1Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Green } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Cyan } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.1.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Cyan } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 2) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 2)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_2.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_2.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_2.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_2.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_2.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_2.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_2.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_2.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit2Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Green } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Cyan } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.2.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Cyan } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 3) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 3)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_3.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_3.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_3.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_3.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_3.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_3.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_3.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_3.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit3Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Green } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Cyan } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.3.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Cyan } }
        }
      }
    }

    WiresGroup
    {
      enabled: (module.layer === FXSectionLayer.fx_primary && module.primaryUnitIdx === 4) ||
               (module.layer === FXSectionLayer.fx_secondary && module.secondaryUnitIdx === 4)

      WiresGroup
      {
        enabled: !shift

        Wire { from: "%surface%.buttons.1";   to: "fx_unit_4.enabled" }
        Wire { from: "%surface%.buttons.2";   to: "fx_unit_4.button1" }
        Wire { from: "%surface%.buttons.3";   to: "fx_unit_4.button2" }
        Wire { from: "%surface%.buttons.4";   to: "fx_unit_4.button3" }

        Wire { from: "softtakeover1.output"; to: "fx_unit_4.dry_wet" }
        Wire { from: "softtakeover2.output"; to: "fx_unit_4.knob1" }
        Wire { from: "softtakeover3.output"; to: "fx_unit_4.knob2" }
        Wire { from: "softtakeover4.output"; to: "fx_unit_4.knob3" }
      }

      WiresGroup
      {
        enabled: shift

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.Single

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Decrement; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.Group

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.DarkOrange } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.1"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.2"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
          Wire { from: "%surface%.buttons.4";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.select.3"; mode: RelativeMode.Increment; wrap: true; color: Color.WarmYellow } }
        }

        WiresGroup
        {
          enabled: fxUnit4Type.value == FxType.PatternPlayer

          Wire { from: "%surface%.buttons.1";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.type"; mode: RelativeMode.Increment; wrap: true; color: Color.Green } }
          Wire { from: "%surface%.buttons.2";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.kitSelect"; mode: RelativeMode.Decrement; wrap: true; color: Color.Cyan } }
          Wire { from: "%surface%.buttons.3";   to: RelativePropertyAdapter{ path: "app.traktor.fx.4.kitSelect"; mode: RelativeMode.Increment; wrap: true; color: Color.Cyan } }
        }
      }
    }
  }

  // Mixer Mode
  readonly property string mixer_prefix: "app.traktor.mixer.channels."
  AppProperty { id: mixerFXType; path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.select" }
  AppProperty { id: mixerFXOn; path: "app.traktor.mixer.channels." + module.deckIdx + ".fx.on" }
  
  WiresGroup
  {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1)
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1) && !(mixerStemOverlayProp.value && ( (deckTypeProp.value == DeckType.Stem) || (deckTypeProp.value == DeckType.Remix) ) )

    Wire { enabled: !shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.mid_low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (!shift && !customMixerVolumeOnShiftProp.value) || (shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (shift && !customMixerVolumeOnShiftProp.value) || (!shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.1.gain";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { enabled: !shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_high"; color: Color.Blue } }
    Wire { enabled: shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_mid";  color: Color.Turquoise } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_low";  color: Color.Red } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.eq.kill_mid_low";  color: Color.DarkOrange } }
    Wire { enabled: !shift; from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.fx.on";  color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange } }
    Wire {
      enabled: shift
      from: "%surface%.buttons.3"
      to: ButtonScriptAdapter {
        color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange;
        brightness: mixerFXOn.value;
        onPress: {
          if (mixerFXType.value < 4) mixerFXType.value = mixerFXType.value + 1;
          else mixerFXType.value = 0
        }
      }
    }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.cue"; color: Color.Blue } }
    // Wire { enabled: !(shift && deckTypeProp.value == DeckType.Stem); from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.1.cue"; color: Color.Blue } }
  }

  WiresGroup
  {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 2)
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 2) && !(mixerStemOverlayProp.value && ( (deckTypeProp.value == DeckType.Stem) || (deckTypeProp.value == DeckType.Remix) ) )

    Wire { enabled: !shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.mid_low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (!shift && !customMixerVolumeOnShiftProp.value) || (shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (shift && !customMixerVolumeOnShiftProp.value) || (!shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.2.gain";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { enabled: !shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_high"; color: Color.Blue } }
    Wire { enabled: shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_mid";  color: Color.Turquoise } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_low";  color: Color.Red } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.eq.kill_mid_low";  color: Color.DarkOrange } }
    Wire { enabled: !shift; from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.fx.on";  color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange } }
    Wire {
      enabled: shift
      from: "%surface%.buttons.3"
      to: ButtonScriptAdapter {
        color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange;
        brightness: mixerFXOn.value;
        onPress: {
          if (mixerFXType.value < 4) mixerFXType.value = mixerFXType.value + 1;
          else mixerFXType.value = 0
        }
      }
    }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.cue"; color: Color.Blue } }
    // Wire { enabled: !(shift && deckTypeProp.value == DeckType.Stem); from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.2.cue"; color: Color.Blue } }
  }

  WiresGroup
  {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 3)
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 3) && !(mixerStemOverlayProp.value && ( (deckTypeProp.value == DeckType.Stem) || (deckTypeProp.value == DeckType.Remix) ) )

    Wire { enabled: !shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.mid_low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (!shift && !customMixerVolumeOnShiftProp.value) || (shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (shift && !customMixerVolumeOnShiftProp.value) || (!shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.3.gain";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { enabled: !shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_high"; color: Color.Blue } }
    Wire { enabled: shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_mid";  color: Color.Turquoise } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_low";  color: Color.Red } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.eq.kill_mid_low";  color: Color.DarkOrange } }
    Wire { enabled: !shift; from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.fx.on";  color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange } }
    Wire {
      enabled: shift
      from: "%surface%.buttons.3"
      to: ButtonScriptAdapter {
        color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange;
        brightness: mixerFXOn.value;
        onPress: {
          if (mixerFXType.value < 4) mixerFXType.value = mixerFXType.value + 1;
          else mixerFXType.value = 0
        }
      }
    }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.cue"; color: Color.Blue } }
    // Wire { enabled: !(shift && deckTypeProp.value == DeckType.Stem); from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.3.cue"; color: Color.Blue } }
  }

  WiresGroup
  {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 4)
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 4) && !(mixerStemOverlayProp.value && ( (deckTypeProp.value == DeckType.Stem) || (deckTypeProp.value == DeckType.Remix) ) )

    Wire { enabled: !shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.high"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: shift; from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.mid";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.mid_low";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.adjust";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (!shift && !customMixerVolumeOnShiftProp.value) || (shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.volume";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { enabled: (shift && !customMixerVolumeOnShiftProp.value) || (!shift && customMixerVolumeOnShiftProp.value); from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "app.traktor.mixer.channels.4.gain";  ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }

    Wire { enabled: !shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_high"; color: Color.Blue } }
    Wire { enabled: shift; from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_mid";  color: Color.Turquoise } }
    Wire { enabled: !(customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_low";  color: Color.Red } }
    Wire { enabled: (customMixerMidLowProp.value && ((!customMixerLowOnShiftProp.value && shift) || (customMixerLowOnShiftProp.value && !shift))); from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.eq.kill_mid_low";  color: Color.DarkOrange } }
    Wire { enabled: !shift; from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.fx.on";  color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange } }
    Wire {
      enabled: shift
      from: "%surface%.buttons.3"
      to: ButtonScriptAdapter {
        color: (mixerFXType.value == 1) ? Color.Red : (mixerFXType.value == 2) ? Color.Green : (mixerFXType.value == 3) ? Color.Turquoise : (mixerFXType.value == 4) ? Color.Yellow : Color.LightOrange;
        brightness: mixerFXOn.value;
        onPress: {
          if (mixerFXType.value < 4) mixerFXType.value = mixerFXType.value + 1;
          else mixerFXType.value = 0
        }
      }
    }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.cue"; color: Color.Blue } }
    // Wire { enabled: !(shift && deckTypeProp.value == DeckType.Stem); from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.mixer.channels.4.cue"; color: Color.Blue } }
  }

  // Stem controls
  StemDeckStreams { name: "stems"; channel: module.deckIdx }
  MappingPropertyDescriptor { id: mixerStemOverlayProp; path: module.propertiesPath + ".mixer_stem_overlay_active"; type: MappingPropertyDescriptor.Boolean; value: false }
  AppProperty { id: deckTypeProp; path: "app.traktor.decks." + module.deckIdx + ".type" }
  
  AppProperty { id: stemColorId_1;  path: "app.traktor.decks." + module.deckIdx + ".stems.1.color_id" }
  AppProperty { id: stemColorId_2;  path: "app.traktor.decks." + module.deckIdx + ".stems.2.color_id" }
  AppProperty { id: stemColorId_3;  path: "app.traktor.decks." + module.deckIdx + ".stems.3.color_id" }
  AppProperty { id: stemColorId_4;  path: "app.traktor.decks." + module.deckIdx + ".stems.4.color_id" }
  
  // AppProperty { id: remixPlayersColorIdProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.1.rows." + remixPlayersActiveCellProp_1.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.2.rows." + remixPlayersActiveCellProp_2.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.3.rows." + remixPlayersActiveCellProp_3.value + ".color_id"; }
  // AppProperty { id: remixPlayersColorIdProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.4.rows." + remixPlayersActiveCellProp_4.value + ".color_id"; }
  AppProperty { id: remixPlayersColorIdProp_1; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.1.rows." + remixPlayersActiveCellProp_1.value + ".animation.color_id.2"; }
  AppProperty { id: remixPlayersColorIdProp_2; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.2.rows." + remixPlayersActiveCellProp_2.value + ".animation.color_id.2"; }
  AppProperty { id: remixPlayersColorIdProp_3; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.3.rows." + remixPlayersActiveCellProp_3.value + ".animation.color_id.2"; }
  AppProperty { id: remixPlayersColorIdProp_4; path: "app.traktor.decks." + module.deckIdx + ".remix.cell.columns.4.rows." + remixPlayersActiveCellProp_4.value + ".animation.color_id.2"; }

  // WiresGroup {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem

    // Wire { from: "%surface%.buttons.1"; to: "stems.1.muted" }
    // Wire { from: "%surface%.buttons.2"; to: "stems.2.muted" }
    // Wire { from: "%surface%.buttons.3"; to: "stems.3.muted" }
    // Wire { from: "%surface%.buttons.4"; to: "stems.4.muted" }

 // }
      
  // WiresGroup {
    // enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem

    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.1.muted"; color: stemColorId_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.2.muted"; color: stemColorId_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.3.muted"; color: stemColorId_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.4.muted"; color: stemColorId_4.value; invertBrightness: true  } }

 // }
            
  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.1.stems_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.1.stems_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.1.stems_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.1.stems_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.1.muted"; color: stemColorId_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.2.muted"; color: stemColorId_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.3.muted"; color: stemColorId_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.4.muted"; color: stemColorId_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.1.fx_send_on"; color: stemColorId_1.value } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.2.fx_send_on"; color: stemColorId_2.value } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.3.fx_send_on"; color: stemColorId_3.value } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.stems.4.fx_send_on"; color: stemColorId_4.value } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 2) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.2.stems_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.2.stems_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.2.stems_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.2.stems_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.1.muted"; color: stemColorId_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.2.muted"; color: stemColorId_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.3.muted"; color: stemColorId_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.4.muted"; color: stemColorId_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.1.fx_send_on"; color: stemColorId_1.value } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.2.fx_send_on"; color: stemColorId_2.value } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.3.fx_send_on"; color: stemColorId_3.value } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.stems.4.fx_send_on"; color: stemColorId_4.value } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 3) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.3.stems_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.3.stems_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.3.stems_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.3.stems_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.1.muted"; color: stemColorId_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.2.muted"; color: stemColorId_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.3.muted"; color: stemColorId_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.4.muted"; color: stemColorId_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.1.fx_send_on"; color: stemColorId_1.value } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.2.fx_send_on"; color: stemColorId_2.value } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.3.fx_send_on"; color: stemColorId_3.value } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.stems.4.fx_send_on"; color: stemColorId_4.value } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 4) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Stem
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.4.stems_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.4.stems_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.4.stems_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.4.stems_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.1.muted"; color: stemColorId_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.2.muted"; color: stemColorId_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.3.muted"; color: stemColorId_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.4.muted"; color: stemColorId_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.1.fx_send_on"; color: stemColorId_1.value } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.2.fx_send_on"; color: stemColorId_2.value } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.3.fx_send_on"; color: stemColorId_3.value } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.stems.4.fx_send_on"; color: stemColorId_4.value } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 1) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Remix
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.1.remix_players_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.1.remix_players_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.1.remix_players_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.1.remix_players_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.1.muted"; color: remixPlayersColorIdProp_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.2.muted"; color: remixPlayersColorIdProp_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.3.muted"; color: remixPlayersColorIdProp_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.4.muted"; color: remixPlayersColorIdProp_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.1.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.2.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.3.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.1.remix.players.4.fx_send_on"; color: Color.LightOrange } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 2) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Remix
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.2.remix_players_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.2.remix_players_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.2.remix_players_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.2.remix_players_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.1.muted"; color: remixPlayersColorIdProp_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.2.muted"; color: remixPlayersColorIdProp_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.3.muted"; color: remixPlayersColorIdProp_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.4.muted"; color: remixPlayersColorIdProp_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.1.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.2.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.3.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.2.remix.players.4.fx_send_on"; color: Color.LightOrange } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 3) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Remix
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.3.remix_players_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.3.remix_players_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.3.remix_players_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.3.remix_players_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.1.muted"; color: remixPlayersColorIdProp_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.2.muted"; color: remixPlayersColorIdProp_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.3.muted"; color: remixPlayersColorIdProp_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.4.muted"; color: remixPlayersColorIdProp_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.1.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.2.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.3.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.3.remix.players.4.fx_send_on"; color: Color.LightOrange } }
  }

  WiresGroup {
    enabled: module.active && (module.layer == FXSectionLayer.mixer) && (module.deckIdx == 4) && mixerStemOverlayProp.value && deckTypeProp.value == DeckType.Remix
    Wire { from: "softtakeover1.output"; to: ValuePropertyAdapter { path: "mapping.state.4.remix_players_1_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover2.output"; to: ValuePropertyAdapter { path: "mapping.state.4.remix_players_2_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover3.output"; to: ValuePropertyAdapter { path: "mapping.state.4.remix_players_3_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    Wire { from: "softtakeover4.output"; to: ValuePropertyAdapter { path: "mapping.state.4.remix_players_4_volume_filter"; ignoreEvents: PinEvent.WireEnabled | PinEvent.WireDisabled } }
    // Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.1.muted"; color: remixPlayersColorIdProp_1.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.2.muted"; color: remixPlayersColorIdProp_2.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.3.muted"; color: remixPlayersColorIdProp_3.value; invertBrightness: true } }
    // Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.4.muted"; color: remixPlayersColorIdProp_4.value; invertBrightness: true  } }
    Wire { from: "%surface%.buttons.1"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.1.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.2"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.2.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.3"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.3.fx_send_on"; color: Color.LightOrange } }
    Wire { from: "%surface%.buttons.4"; to: TogglePropertyAdapter { path: "app.traktor.decks.4.remix.players.4.fx_send_on"; color: Color.LightOrange } }
  }

}
