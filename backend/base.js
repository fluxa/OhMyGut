//BaseResponse

exports.response = function(success,arg) {

	if(success){
		return {
			success:true,
			data:arg
		}
	}else{
		return{
			success:false,
			error:{
				message:arg[0],
				code:arg[1]
			}
		}
	}
};

exports.code = {
	ok:'OK',
	user_exists:'USER_EXISTS',
	missing_parameters:'MISSING_PARAMETERS',
	database_error:'DATABASE_ERROR',
	game_already_finished:'GAME_ALREADY_FINISHED',
	game_player_inconsistency:'GAME_PLAYER_INCONSISTENCY'
};

exports.info = {
	title:"Medusa",
	brand:"reigndesign"
}