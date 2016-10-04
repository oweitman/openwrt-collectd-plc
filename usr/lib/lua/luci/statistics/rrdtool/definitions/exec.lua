module("luci.statistics.rrdtool.definitions.exec", package.seeall)

function rrdargs(graph, plugin, plugin_instance)
    -- For $HOSTNAME/exec-foo-bar/temperature_baz-quux.rrd, plugin will be
    -- "exec" and plugin_instance will be "foo-bar".  I guess graph will be
    -- "baz-quux"?  We may also be ignoring a fourth argument, dtype.
        return {
            per_instance=true,
            title = "PLC speed / %H / %di",
            vlabel = "MBit/s",
            data = {
			types   = { "plc_RX", "plc_TX" },
			options = { 
				plc_RX = {
					noarea = true, 
					overlay = true, 
					title = "RX",
					color = "0000ff"
				}, 
				plc_TX = {
					noarea = true, 
					overlay = true, 
					title = "TX", 
					color = "ff0000"
				} 
			}
            }
        }
end
