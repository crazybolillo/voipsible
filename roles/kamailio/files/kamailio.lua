function ksr_request_route()
	if validate_request() ~= 0 then
		KSR.x.exit()
	end

	local res = 1
	if KSR.is_REGISTER() then
		res = 0
		KSR.dispatcher.ds_select_dst(1, 4)
	elseif KSR.siputils.has_totag() < 0 then
		res = create_dialog()
	else
		res = process_dialog()
	end

	if res ~= 0 then
		KSR.x.exit()
	end

	KSR.tm.t_relay()
end

function validate_request()
	local max_forward = 10
	local maxfwd_check = KSR.maxfwd.process_maxfwd(max_forward)
	if maxfwd_check < 0 then
		KSR.err("too many hops sending 483")
		KSR.sl.sl_send_reply(483, "Too Many Hops")

		return 1
	end

	local sanity_check = KSR.sanity.sanity_check_defaults()
	if sanity_check < 0 then
		KSR.err("sanity check failed")
		return 1
	end

	return 0
end

function process_dialog()
	KSR.rr.record_route()
	KSR.dialog.dlg_manage()

	if KSR.is_INVITE() then
		KSR.rtpengine.rtpengine_manage("external internal")
	elseif KSR.is_BYE() then
		KSR.rtpengine.rtpengine_delete0()
	end

	return 0
end

function create_dialog()
	KSR.rr.record_route()

	if not KSR.is_INVITE() then
		KSR.sl.sl_send_reply(501, "Method " .. KSR.pv.get("$rm") .. " is not implemented")
		return 1
	end

	KSR.rtpengine.rtpengine_manage("external internal")
	KSR.dispatcher.ds_select_dst(1, 4)

	return 0
end

function ksr_reply_route()
	KSR.rtpengine.rtpengine_manage("internal external")
end
