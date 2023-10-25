%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%%
%%% @end
%%% Created : 25 Oct 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_zigbee_devices).

-include("device.hrl").

%% API
-export([
	 get_num_map_module/1,
	 all/0,
	 all_raw/0,
	 present/0
	]).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_num_map_module(Name)->
    TYpeNumIdMapList= [{Type,NumId,Map}||{Type,NumId,Map}<-all_raw(),
					 Name=:=binary_to_list(maps:get(<<"name">>,Map))],
    case TYpeNumIdMapList of
	[]->
	    {error,["Name not found",Name,?MODULE,?LINE]};
	[{Type,NumId,Map}|_]->
	    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
	    [Module]=[maps:get(module,DeviceMap)||DeviceMap<-?DeviceInfo,
						  ModelId=:=maps:get(modelid,DeviceMap)],
	    {ok,Type,NumId,Map,Module}
			       
    end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
present()->
    


    ok.


%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
all_raw()->
    Result=case rd:call(phoscon_control,get_maps,[],5000) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       TypeMaps->
		   get_info_raw(TypeMaps,[])
	   end,
    Result.

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
all()->
    Result=case rd:call(phoscon_control,get_maps,[],5000) of
	       {error,Reason}->
		   {error,[Reason,?MODULE,?LINE]};
	       TypeMaps->
		   get_info(TypeMaps,[])
	   end,
    Result.



%%%===================================================================
%%% Internal functions
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_info_raw([],Acc)->
    lists:append(Acc);
get_info_raw([{Type,Map}|T],Acc)->
    L=maps:to_list(Map),
    AllMaps=format_info_raw(L,Type,[]),
    get_info_raw(T,[AllMaps|Acc]).

format_info_raw([],_Type,Acc)->
    Acc;
format_info_raw([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    format_info_raw(T,Type,[{Type,NumId,Map}|Acc]).
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_info([],Acc)->
    lists:append(Acc);
get_info([{Type,Map}|T],Acc)->
    L=maps:to_list(Map),
    AllInfo=format_info(L,Type,[]),
    get_info(T,[AllInfo|Acc]).
    
format_info([],_Type,Acc)->
    Acc;
format_info([{NumIdBin,Map}|T],Type,Acc)->
    NumId=binary_to_list(NumIdBin),
    Name=binary_to_list(maps:get(<<"name">> ,Map)),
    ModelId=binary_to_list(maps:get(<<"modelid">>,Map)),
    format_info(T,Type,[{Type,NumId,Name,ModelId}|Acc]).


	   
