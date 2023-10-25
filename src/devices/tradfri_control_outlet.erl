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
	 is_reachable/1,
	 is_on/1,
	 is_off/1,
	 turn_on/1,
	 turn_off/1
	]). 


%% ====================================================================
%% External functions
%% ====================================================================


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_reachable(Name)->
    case get_info(Name) of
	[]->
	    {error,["Name not found",Name,?MODULE,?LINE]};
	[{?Type,_NumId,Map}]->
	    StateMap=maps:get(<<"state">>,Map),
	    maps:get(<<"reachable">>,StateMap)
    end.
	   
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
is_on(Name)->
    case get_info(Name) of
	[]->
	    {error,["Name not found",Name,?MODULE,?LINE]};
	[{?Type,_NumId,Map}]->
	    StateMap=maps:get(<<"state">>,Map),
	    case maps:get(<<"reachable">>,StateMap) of
		false->
		    {error,["Name is not reachable",Name,?MODULE,?LINE]};
		true->
		    maps:get(<<"on">>,StateMap)
	    end
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
is_off(Name)->
    false=:=is_on(Name).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_on(Name)->
    case get_info(Name) of
	[]->
	    {error,["Name not found",Name,?MODULE,?LINE]};
	[{?Type,NumId,Map}]->
	    StateMap=maps:get(<<"state">>,Map),
	    case maps:get(<<"reachable">>,StateMap) of
		false->
		    {error,["Name is not reachable",Name,?MODULE,?LINE]};
		true->
		    Id=NumId,
		    Key=list_to_binary("on"),
		    Value=true,
		    DeviceType=?Type,
		    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
	    end
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
turn_off(Name)->
    case get_info(Name) of
	[]->
	    {error,["Name not found",Name,?MODULE,?LINE]};
	[{?Type,NumId,Map}]->
	    StateMap=maps:get(<<"state">>,Map),
	    case maps:get(<<"reachable">>,StateMap) of
		false->
		    {error,["Name is not reachable",Name,?MODULE,?LINE]};
		true->
		    Id=NumId,
		    Key=list_to_binary("on"),
		    Value=false,
		    DeviceType=?Type,
		    rd:call(phoscon_control,set_state,[Id,Key,Value,DeviceType],5000)
	    end
    end.


%% ====================================================================
%% Internal functions
%% ====================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_info(Name)->
    Result= [{?Type,NumId,Map}||{?Type,NumId,Map}<-zigbee_devices:all_raw(),
				Name=:=binary_to_list(maps:get(<<"name">>,Map)),
				?ModelId=:=binary_to_list(maps:get(<<"modelid">>,Map))],
    Result.


		    
    
