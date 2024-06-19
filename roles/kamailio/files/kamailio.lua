function ksr_request_route()
	if not KSR.sanity.sanity_check_defaults() then
		KSR.x.exit()
	end

	if KSR.is_INVITE() then
		KSR.rtpengine.rtpengine_manage0()
	end

	local target = KSR.kx.get_def("ASTERISK_ADDR")
	KSR.forward_uri(string.format("sip:%s;transport=tcp", target))
end

function ksr_reply_route()
	KSR.rtpengine.rtpengine_manage0()
	KSR.hdr.remove("Server")
end
