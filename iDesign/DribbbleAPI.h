//
//  DribbbleAPI.h
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#ifndef iDesign_DribbbleAPI_h
#define iDesign_DribbbleAPI_h

//============== Application的授权信息 ========
#define OAuth2_CLIENT_ID @"01e27a6ed6141e213d6d4ec8753887dc2e8573813bc1acb41f4d92d814768cc0"
#define OAuth2_CLIENT_SECRET @"a5b1b405e8a319819bd269d390a9af2c25cfa140e887273bb9b06f66c6128bf8"
#define OAuth2_CLIENT_ACCESS_TOKEN @"99edd58b8df0fd8a5c7f3f1c90c736910710e94233c4cb82617b60f75169ffb3"

//=============== Dribbble的请求地址 ========
#define OAuth2_BASE_URL @"https://api.dribbble.com/v1/"

#define OAuth2_AuthorizationUrl @"https://dribbble.com/oauth/authorize"
#define OAuth2_TokenUrl @"https://dribbble.com/oauth/token"
#define OAuth2_RedirectUrl @"http://yinpans.com/idesign"
#define OAuth2_DRIBBBLE_SCOPES [NSSet setWithObjects:@"public", @"write", @"upload", @"comment", nil]
#define DRIBBBLE_POPUPLAR @"https://api.dribbble.com/v1/shots?sort="
#define DRIBBBLE_EVERYONE @"https://api.dribbble.com/v1/shots?sort=everyone"
#define DRIBBBLE_DEBUTS @"https://api.dribbble.com/v1/shots?sort=debuts"
#define DRIBBBLE_SHOTS @"https://api.dribbble.com/v1/shots/"
#define DRIBBBLE_SEARCH @"http://tranquil-castle-5793.herokuapp.com/search"

#endif
