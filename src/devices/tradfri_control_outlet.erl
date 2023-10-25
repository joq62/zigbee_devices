%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(tradfri_control_outlet).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"TRADFRI control outlet").
-define(Type,"lights").
%% --------------------------------------------------------------------
% {"lights","13",
%           #{<<"etag">> => <<"7446fcc9423ed952e0651340cca23573">>,
%             <<"hascolor">> => false,<<"lastannounced">> => null,
%             <<"lastseen">> => <<"2023-09-13T18:41Z">>,
%             <<"manufacturername">> => <<"IKEA of Sweden">>,
%             <<"modelid">> => <<"TRADFRI control outlet">>,
%             <<"name">> => <<"outlet_1">>,
%             <<"state">> =>
%                 #{<<"alert">> => <<"none">>,<<"on">> => false,
%                   <<"reachable">> => false},
%             <<"swversion">> => <<"2.0.024">>,
%             <<"type">> => <<"On/Off plug-in unit">>,
%             <<"uniqueid">> => <<"94:34:69:ff:fe:01:4e:b0-01">>}},



%% External exports
-export([
	 is_reachable/3,
	 is_on/3,
	 is_off/3,
	 turn_on/3,
	 turn_off/3
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable([],_NumId,Map)->
    StateMap=maps:get(<<"state">>,Map),
    maps:get(<<"reachable">>,StateMap).
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on([],_NumId,Map)->
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
is_off([],NumId,Map)->
    false=:=is_on([],NumId,Map).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_on([],NumId,Map)->
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
turn_off([],NumId,Map)->
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


		    
    
