%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_magnetic).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.sensor.magnetic.aq2").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%  {"sensors","8",
%           #{<<"config">> =>
%                 #{<<"battery">> => 100,<<"on">> => true,
%                   <<"reachable">> => true,<<"temperature">> => 2300},
%             <<"ep">> => 1,
%             <<"etag">> => <<"dbf413aedbe44bec3ed17a5736bf4ba6">>,
%             <<"lastannounced">> => null,
%             <<"lastseen">> => <<"2023-11-01T20:19Z">>,
%             <<"manufacturername">> => <<"LUMI">>,
%             <<"modelid">> => <<"lumi.sensor_magnet.aq2">>,
%             <<"name">> => <<"lumi_magnet_1">>,
%             <<"state">> =>
%                 #{<<"lastupdated">> => <<"2023-11-01T20:19:55.142">>,
%                   <<"open">> => true},
%             <<"swversion">> => <<"20161128">>,
%             <<"type">> => <<"ZHAOpenClose">>,
%             <<"uniqueid">> => <<"00:15:8d:00:06:89:6d:bb-01-0006">>}},


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


		    
    
