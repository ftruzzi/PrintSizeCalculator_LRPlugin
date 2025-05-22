# Print Size Calculator Plugin for Lightroom Classic

This plugin calculates and displays the **print size** of a photo based on a standard **300 PPI** resolution.

<br/>

<div align="center">
   <img src="https://i.imgur.com/zfvIeDG.png" width="500" />
</div>

## Installation

1. Clone this repository, or download the latest release from [Releases](https://github.com/ftruzzi/PrintSizeCalculator_LRPlugin/releases)
2. Extract the ZIP file if needed
3. Open Lightroom, and add the plugin from File -> Plug-in Manager
4. Configure your preferred unit of measurement (centimeters or inches)

After installation, the print size will be visible under the "All Plug-in Metadata" preset in the Metadata panel.

### Adding to Default Metadata View (Optional)

To add print size to your default Metadata panel view, follow these steps for your operating system:

**macOS:**
1. Open `~/Library/Application Support/Adobe/Lightroom/Metadata/DefaultPanel.lua`
2. Add this line to the end of the metadata fields list:

   ```lua
   "com.ftruzzi.printsizecalculator.recommendedPrintSize"
   ```

**Windows:**
1. Open `C:\Users\{YourName}\AppData\Roaming\Adobe\Lightroom\Metadata\DefaultPanel.lua`
2. Add this line to the end of the metadata fields list:

   ```lua
   "com.ftruzzi.printsizecalculator.recommendedPrintSize"
   ```

Note: Restart Lightroom after making these changes for them to take effect.
