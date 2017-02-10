switch (mPos){

    case 0:
        room_goto_next();
        audio_stop_sound(snd_boss);
        break;
    case 1:
        game_end();
        break;
    default:
        break;

}
