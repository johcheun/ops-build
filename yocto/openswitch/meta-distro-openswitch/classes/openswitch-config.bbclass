#
# Parse .ops-config file and convert config symbols to a format which build
# system understands.
#
# .ops-config is autogenerated by Kconfig system. Following holds true with
# respect to autogenerated Kconfig symbols for OpenSwitch:
#
#  - Disabled symbols are either not present or commented out (start with '#')
#  - All enabled symbols start with OPS_CONFIG_
#  - '=' separates symbols from values assigned.
#  - Enabled bool symbols end with '=y' and are added to IMAGE_FEATURES
#    provided they are part of the master mapping file.
#  - Enabled symbols not ending with '=y' are of type string/hex/int and
#    passed on to build system as key-value pairs.
#
# Current limitations of parser logic:
#  - Symbols of type 'tristate' (modules) are not supported
#
def get_ops_config_symbols(d):
    config_file_path = d.getVar("TOPDIR") + "/.ops-config"
    devenv_conf_file_path = d.getVar("BUILD_ROOT") + "/yocto/openswitch/meta-distro-openswitch/devenv.conf"
    ops_feature = ""

    try:
        config_file = open(config_file_path, "r")
    except IOError:
        print ".ops-config file not found"
        return ops_feature

    try:
        devenv_conf_file = open(devenv_conf_file_path, "r")
    except IOError:
        print "devenv.conf file not found"
        config_file.close()
        return ops_feature

    # Pick enabled symbols
    for line in config_file:
        line = line.strip()

        if line.startswith("OPS_CONFIG_"):
            # Get Kconfig symbol
            config_param = line.split('=', 1)

            if config_param[1] == 'y':
                # This is a feature
                config_symbol = config_param[0].split('_', 2)[2]
                ops_feature += config_symbol + " "

                # Map Kconfig feature symbol to package
                ops_package = "ops-" + config_symbol.lower()
                devenv_conf_file.seek(1)
                if ops_package not in devenv_conf_file.read():
                    ops_package = ""

                # Create empty FEATURE_PACKAGES for enabled symbols
                feature_package = "FEATURE_PACKAGES_" + config_symbol
                d.setVar(feature_package, ops_package)
            else:
                # Key value pair. Add to data store
                config_symbol = config_param[0].split('_', 2)[2]
                d.setVar(config_symbol, config_param[1])

    config_file.close()
    devenv_conf_file.close()
    return ops_feature
