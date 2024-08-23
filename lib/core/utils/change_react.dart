changeReaction(dynamic currentPost, String react) async {
  try {
    if (react == 'sad') {
      if (currentPost?.isSad == false) {
        print("saddddd");
        if (currentPost?.isLikes == true) {
          currentPost?.isLikes = false;
          currentPost?.likesCount = (currentPost.likesCount! - 1);
        } else if (currentPost?.isLove == true) {
          currentPost?.isLove = false;
          currentPost?.loveCount = (currentPost.loveCount! - 1);
        } else if (currentPost?.isWow == true) {
          currentPost?.isWow = false;
          currentPost?.wowCount = (currentPost.wowCount! - 1);
        } else if (currentPost?.isAngry == true) {
          currentPost?.isAngry = false;
          currentPost?.angryCount = (currentPost.angryCount! - 1);
        } else if (currentPost?.isHaha == true) {
          currentPost?.isHaha = false;
          currentPost?.hahaCount = (currentPost.hahaCount! - 1);
        }
        currentPost?.isSad == true;
        currentPost?.sadCount = (currentPost.sadCount! + 1);
      } else {
        currentPost?.isSad == false;
        currentPost?.sadCount = (currentPost.sadCount! - 1);
      }
    } else if (react == 'love') {
      if (currentPost?.isLove == false) {
        if (currentPost?.isLikes == true) {
          currentPost?.isLikes = false;
          currentPost?.likesCount = (currentPost.likesCount! - 1);
        } else if (currentPost?.isSad == true) {
          currentPost?.isSad = false;
          currentPost?.sadCount = (currentPost.sadCount! - 1);
        } else if (currentPost?.isWow == true) {
          currentPost?.isWow = false;
          currentPost?.wowCount = (currentPost.wowCount! - 1);
        } else if (currentPost?.isAngry == true) {
          currentPost?.isAngry = false;
          currentPost?.angryCount = (currentPost.angryCount! - 1);
        } else if (currentPost?.isHaha == true) {
          currentPost?.isHaha = false;
          currentPost?.hahaCount = (currentPost.hahaCount! - 1);
        }
        currentPost?.isLove == true;
        currentPost?.loveCount = (currentPost.loveCount! + 1);
      } else {
        currentPost?.isLove == false;
        currentPost?.loveCount = (currentPost.loveCount! - 1);
      }
    } else if (react == 'wow') {
      if (currentPost?.isWow == false) {
        if (currentPost?.isLikes == true) {
          currentPost?.isLikes = false;
          currentPost?.likesCount = (currentPost.likesCount! - 1);
        } else if (currentPost?.isSad == true) {
          currentPost?.isSad = false;
          currentPost?.sadCount = (currentPost.sadCount! - 1);
        } else if (currentPost?.isLove == true) {
          currentPost?.isLove = false;
          currentPost?.loveCount = (currentPost.loveCount! - 1);
        } else if (currentPost?.isAngry == true) {
          currentPost?.isAngry = false;
          currentPost?.angryCount = (currentPost.angryCount! - 1);
        } else if (currentPost?.isHaha == true) {
          currentPost?.isHaha = false;
          currentPost?.hahaCount = (currentPost.hahaCount! - 1);
        }
        currentPost?.isWow == true;
        currentPost?.wowCount = (currentPost.wowCount! + 1);
      } else {
        currentPost?.isWow == false;
        currentPost?.wowCount = (currentPost.wowCount! - 1);
      }
    } else if (react == 'likes' || react == 'like') {
      if (currentPost?.isLikes == false) {
        if (currentPost?.isLove == true) {
          currentPost?.isLove = false;
          currentPost?.loveCount = (currentPost.loveCount! - 1);
        } else if (currentPost?.isSad == true) {
          currentPost?.isSad = false;
          currentPost?.sadCount = (currentPost.sadCount! - 1);
        } else if (currentPost?.isWow == true) {
          currentPost?.isWow = false;
          currentPost?.wowCount = (currentPost.wowCount! - 1);
        } else if (currentPost?.isAngry == true) {
          currentPost?.isAngry = false;
          currentPost?.angryCount = (currentPost.angryCount! - 1);
        } else if (currentPost?.isHaha == true) {
          currentPost?.isHaha = false;
          currentPost?.hahaCount = (currentPost.hahaCount! - 1);
        }
        currentPost?.isLikes == true;
        currentPost?.likesCount = (currentPost.likesCount! + 1);
      } else {
        currentPost?.isLikes == false;
        currentPost?.likesCount = (currentPost.likesCount! - 1);
      }
    } else if (react == 'angry') {
      if (currentPost?.isAngry == false) {
        if (currentPost?.isLikes == true) {
          currentPost?.isLikes = false;
          currentPost?.likesCount = (currentPost.likesCount! - 1);
        } else if (currentPost?.isSad == true) {
          currentPost?.isSad = false;
          currentPost?.sadCount = (currentPost.sadCount! - 1);
        } else if (currentPost?.isWow == true) {
          currentPost?.isWow = false;
          currentPost?.wowCount = (currentPost.wowCount! - 1);
        } else if (currentPost?.isLove == true) {
          currentPost?.isLove = false;
          currentPost?.loveCount = (currentPost.loveCount! - 1);
        } else if (currentPost?.isHaha == true) {
          currentPost?.isHaha = false;
          currentPost?.hahaCount = (currentPost.hahaCount! - 1);
        }
        currentPost?.isAngry == true;
        currentPost?.angryCount = (currentPost.angryCount! + 1);
      } else {
        currentPost?.isAngry == false;
        currentPost?.angryCount = (currentPost.angryCount! - 1);
      }
    } else if (react == 'haha') {
      if (currentPost?.isHaha == false) {
        if (currentPost?.isLikes == true) {
          currentPost?.isLikes = false;
          currentPost?.likesCount = (currentPost.likesCount! - 1);
        } else if (currentPost?.isSad == true) {
          currentPost?.isSad = false;
          currentPost?.sadCount = (currentPost.sadCount! - 1);
        } else if (currentPost?.isWow == true) {
          currentPost?.isWow = false;
          currentPost?.wowCount = (currentPost.wowCount! - 1);
        } else if (currentPost?.isLove == true) {
          currentPost?.isLove = false;
          currentPost?.loveCount = (currentPost.loveCount! - 1);
        } else if (currentPost?.isAngry == true) {
          currentPost?.isAngry = false;
          currentPost?.angryCount = (currentPost.angryCount! - 1);
        }
        currentPost?.isHaha == true;
        currentPost?.hahaCount = (currentPost.hahaCount! + 1);
      } else {
        currentPost?.isHaha == false;
        currentPost?.hahaCount = (currentPost.hahaCount! - 1);
      }
    }
  } catch (_) {
    return '';
  }
}
