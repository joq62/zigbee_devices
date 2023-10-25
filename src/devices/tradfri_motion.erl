%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_motion).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRI motion sensor").
-define(Type,"sensors").
%% --------------------------------------------------------------------
%  {"sensors","7",
 %          #{<<"config">> =>
 %                #{<<"alert">> => <<"none">>,<<"battery">> => 74,
 %                  <<"delay">> => 180,<<"duration">> => 60,
 %                  <<"group">> => <<"7">>,<<"on">> => true,
 %                  <<"reachable">> => true},
 %            <<"ep">> => 1,
 %            <<"etag">> => <<"af9f03e3e47e69c65ac84ff3dcfe2dd2">>,
 %            <<"lastannounced">> => <<"2023-10-31T16:58:32Z">>,
 %            <<"lastseen">> => <<"2023-11-01T20:25Z">>,
 %            <<"manufacturername">> => <<"IKEA of Sweden">>,
 %            <<"modelid">> => <<"TRADFRI motion sensor">>,
 %            <<"name">> => <<"tradfri_motion_1">>,
 %            <<"state">> =>
 %                #{<<"dark">> => true,
 %                  <<"lastupdated">> => <<"2023-11-01T20:26:32.675">>,
 %                  <<"presence">> => false},
 %            <<"swversion">> => <<"2.0.022">>,<<"type">> => <<"ZHAPresence">>,
 %            <<"uniqueid">> => <<"84:ba:20:ff:fe:9b:d6:4d-01-0006">>}},

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


		    
    
