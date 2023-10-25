%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%%
%%% @end
%%% Created : 25 Oct 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(lib_zigbee_devices).

%% API
-export([
	all/0
	]).

%%%===================================================================
%%% API
%%%===================================================================

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

	 %   R1=lists:append([maps:to_list(Map)||{_Type,Map}<-Maps]),
	%	    io:format("R1 =~p~n",[{R1,?MODULE,?LINE}]),
		    
	%	    R=[{binary_to_list(maps:get(<<"name">> ,Map)),
	%		binary_to_list(maps:get(<<"modelid">>,Map))			
	%	       }||{NumId,Map}<-R1], 
						%	    R=[Map||{NumId,Map}<-R1],
		    

%%%===================================================================
%%% Internal functions
%%%===================================================================
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


	   
