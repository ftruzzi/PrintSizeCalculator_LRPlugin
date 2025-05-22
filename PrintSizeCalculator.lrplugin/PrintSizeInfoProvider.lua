local LrPrefs = import "LrPrefs"
local LrView = import "LrView"

function genSectionsForBottomOfDialog(viewFactory, p)
  local prefs = LrPrefs.prefsForPlugin( _PLUGIN )
  
  -- Set default unit for first plugin run
  if not prefs.unit then
    prefs.unit = "cm"
  end

  local prefsSection = {
    title = "Preferences",
    viewFactory:row {
      bind_to_object = prefs,
      spacing = viewFactory:control_spacing(),
      viewFactory:popup_menu {
        title = "Unit",
        value = LrView.bind("unit"),
        width = dropDownWidth,
        items = {
          { title = "cm", value = "cm" },
          { title = "in", value = "in" },
        }
      },
      viewFactory:static_text {
        title = 'Your preferred unit for print size calculation.'
      }
    }
  }

  return { prefsSection }
end

return {
  sectionsForBottomOfDialog = genSectionsForBottomOfDialog,
}