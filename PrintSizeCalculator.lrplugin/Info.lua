return {
    LrSdkVersion = 14.0,
    LrSdkMinimumVersion = 14.0,
    LrToolkitIdentifier = 'com.ftruzzi.printsizecalculator',
    LrPluginName = "Print Size Calculator",
    LrPluginInfoUrl = 'https://github.com/ftruzzi/PrintSizeCalculator_LRPlugin',

    LrMetadataProvider = 'PrintSizeMetadataProvider.lua',
    LrInitPlugin = "CalculatePrintSize.lua",
    LrPluginInfoProvider = 'PrintSizeInfoProvider.lua',

    VERSION = { major=0, minor=1, revision=0 },
} 