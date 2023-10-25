%%%-------------------------------------------------------------------
%%% @author c50 <joq62@c50>
%%% @copyright (C) 2023, c50
%%% @doc
%%% 
%%% @end
%%% Created :  2 Jun 2023 by c50 <joq62@c50>
%%%-------------------------------------------------------------------
-module(zigbee_devices). 

-behaviour(gen_server).  
%%--------------------------------------------------------------------
%% Include 
%%
%%--------------------------------------------------------------------

-include("zigbee_devices.resource_discovery").
-include("device.hrl").
-include("log.api").


%% API

%% Application handling API

-export([
	 all/0,
	 present/0
	]).

%% Oam handling API

-export([
%	 all/0,
%	 all_nodes/0,
%	 all_providers/0,
%	 where_is/1,
%	 is_wanted_state/0
	]).



%% Debug API
-export([
%	 create_worker/1,
%	 delete_worker/1,
%	 load_provider/1,
%	 start/1,
%	 stop/1,
%	 unload/1
	
	 
	]).


-export([start/0,
	 ping/0]).


-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3, format_status/2]).

-define(SERVER, ?MODULE).

%% Record and Data
-record(state, {}).

%% Table or Data models



%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec all() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

all() ->
    gen_server:call(?SERVER,{all},infinity).
%%--------------------------------------------------------------------
%% @doc
%% This function is an user interface to be complementary to automated
%% load and start a provider at this host.
%% In v1.0.0 the deployment will not be persistant   
%% @end
%%--------------------------------------------------------------------
-spec present() -> ListOfDeviceName :: term() |{error, Error :: term()}.
%%  Tabels or State
%%

present() ->
    gen_server:call(?SERVER,{present},infinity).



%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
start()->
    application:start(?MODULE).
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%% @end
%%--------------------------------------------------------------------
-spec start_link() -> {ok, Pid :: pid()} |
	  {error, Error :: {already_started, pid()}} |
	  {error, Error :: term()} |
	  ignore.
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------



%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
ping()-> 
    gen_server:call(?SERVER, {ping},infinity).    

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% @end
%%--------------------------------------------------------------------
-spec init(Args :: term()) -> {ok, State :: term()} |
	  {ok, State :: term(), Timeout :: timeout()} |
	  {ok, State :: term(), hibernate} |
	  {stop, Reason :: term()} |
	  ignore.
init([]) ->

    %% Connect nodes
   	
 %% Announce to resource_discovery

    [rd:add_local_resource(ResourceType,Resource)||{ResourceType,Resource}<-?LocalResourceTuples],
    [rd:add_target_resource_type(TargetType)||TargetType<-?TargetTypes],
    rd:trade_resources(), 
    timer:sleep(3000),
    ?LOG_NOTICE("Server started ",[]),
    
 
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%% @end
%%--------------------------------------------------------------------
-spec handle_call(Request :: term(), From :: {pid(), term()}, State :: term()) ->
	  {reply, Reply :: term(), NewState :: term()} |
	  {reply, Reply :: term(), NewState :: term(), Timeout :: timeout()} |
	  {reply, Reply :: term(), NewState :: term(), hibernate} |
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), Reply :: term(), NewState :: term()} |
	  {stop, Reason :: term(), NewState :: term()}.



handle_call({all}, _From, State) ->
   % Reply = case rd:call(lgh_prhoscon,get_maps,[],5000) of
    Reply =lib_zigbee_devices:all(),
    {reply, Reply, State};


handle_call({present}, _From, State) ->
    Reply = case rd:call(phoscon_control,get_maps,[],5000) of
		{error,Reason}->
		    {error,Reason};
		Maps->
		    {ok,Maps}
	    end,
    
    {reply, Reply, State};


handle_call({ping}, _From, State) ->
    Reply = pong,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_cast(Request :: term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: term(), NewState :: term()}.
handle_cast(_Request, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%% @end
%%--------------------------------------------------------------------
-spec handle_info(Info :: timeout() | term(), State :: term()) ->
	  {noreply, NewState :: term()} |
	  {noreply, NewState :: term(), Timeout :: timeout()} |
	  {noreply, NewState :: term(), hibernate} |
	  {stop, Reason :: normal | term(), NewState :: term()}.
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
		State :: term()) -> any().
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(OldVsn :: term() | {down, term()},
		  State :: term(),
		  Extra :: term()) -> {ok, NewState :: term()} |
	  {error, Reason :: term()}.
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called for changing the form and appearance
%% of gen_server status when it is returned from sys:get_status/1,2
%% or when it appears in termination error logs.
%% @end
%%--------------------------------------------------------------------
-spec format_status(Opt :: normal | terminate,
		    Status :: list()) -> Status :: term().
format_status(_Opt, Status) ->
    Status.

%%%===================================================================
%%% Internal functions
%%%===================================================================
check_rd_running(_Interval,N_,true)->
    true;
check_rd_running(Interval,0,true)->
    true;
check_rd_running(Interval,0,false)->
    false;
check_rd_running(Interval,N,IsRunning)->
    case rpc:call(node(),rd,ping,[],5000) of
	pong->
	    NewIsRunning=true,
	    NewN=N;
	_->
	    timer:sleep(Interval),
	    NewIsRunning=false,
	    NewN=N-1
    end,
    check_rd_running(Interval,NewN,NewIsRunning).
	 
