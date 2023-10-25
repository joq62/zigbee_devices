%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_motion).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.sensor.motion.aq2").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%{"sensors","9",
%           #{<<"config">> =>
%                 #{<<"battery">> => 100,<<"on">> => true,
%                   <<"reachable">> => true,<<"temperature">> => 2800,
%                   <<"tholddark">> => 12000,<<"tholdoffset">> => 7000},
%             <<"ep">> => 1,
%             <<"etag">> => <<"96e94adf0c83344fd7ccfdc7b376f754">>,
%             <<"lastannounced">> => <<"2022-12-20T20:22:40Z">>,
%             <<"lastseen">> => <<"2023-11-01T19:45Z">>,
%             <<"manufacturername">> => <<"LUMI">>,
%             <<"modelid">> => <<"lumi.sensor_motion.aq2">>,
%             <<"name">> => <<"lumi_motion_1">>,
%             <<"state">> =>
%                 #{<<"dark">> => true,<<"daylight">> => false,
%                   <<"lastupdated">> => <<"2023-11-01T19:45:28.897">>,
%                   <<"lightlevel">> => 6021,<<"lux">> => 4},
%             <<"swversion">> => <<"20170627">>,
%             <<"type">> => <<"ZHALightLevel">>,
 %            <<"uniqueid">> => <<"00:15:8d:00:01:dd:a2:b8-01-0400">>}},

%% External exports
-export([
	 is_reachable/2,
	 is_on/2,
	 is_off/2,
	 turn_on/2,
	 turn_off/2
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start{/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable([],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    maps:get(<<"reachable">>,StateMap).
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on([],[{_Type,_NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    maps:get(<<"on">>,StateMap)
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
is_off([],ListTypeNumIdMap)->
    false=:=is_on([],ListTypeNumIdMap).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_on([],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=true,
	    DeviceType=?Type,
	    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_off([],[{_Type,NumId,Map}|_])->
    StateMap=maps:get(<<"state">>,Map),
    case maps:get(<<"reachable">>,StateMap) of
	false->
	    {error,["Not reachable",?MODULE,?LINE]};
	true->
	    Id=NumId,
	    Key=list_to_binary("on"),
	    Value=false,
	    DeviceType=?Type,
	    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
    end.


%% ====================================================================
%% Internal functions
%% ====================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------


		    
    
