enum SongsEnum {
  forYou,
  trending,
  saved,
  original;

  String en(){
    switch(this){
      case SongsEnum.forYou:
        return 'For You';
      case SongsEnum.trending:
        return 'Trending';
      case SongsEnum.saved:
        return 'Saved';
      case SongsEnum.original:
        return 'Original Audio';
    }
  }

  String ar() {
    switch (this) {
      case SongsEnum.forYou:
        return 'لك';
      case SongsEnum.trending:
        return 'الأكثر رواجًا';
      case SongsEnum.saved:
        return 'المحفوظة';
      case SongsEnum.original:
        return 'الصوت الأصلي';
    }
  }

}