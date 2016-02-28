//
//  HttpDataTool.m
//  MLPlayer
//
//  Created by robin on 15/6/4.
//  Copyright (c) 2015年 w. All rights reserved.
//

#import "HttpDataTool.h"
#import "ASIHTTPRequest.h"

#define IMAGE_DATASIZE 300*1024

@implementation HttpDataTool

+ (NSDictionary *)getDictionaryFromHttpRequest:(id)request
                                   requestType:(Request_TYPE)type
                                    withResult:(NSString *)responseString {
    NSString *resultString = @"";
    NSDictionary *resultDict = nil;
    
    if (type == Request_Download)
    {
        ASIHTTPRequest *httpRequest = (ASIHTTPRequest *)request;
        resultDict = httpRequest.userInfo;
    }
    else
    {
        if (type == Request_Normal || type == Request_Login || type == Request_H5)
        {
            resultString = responseString;
        }
        else if (type == Request_Upload || type == Request_UploadHead )
        {
            ASIHTTPRequest *httpRequest = (ASIHTTPRequest *)request;
            NSString *unPackResponse = [httpRequest responseString];
            resultString = [STR_IS_NULL(unPackResponse) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        }
        
        NSData *data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        resultDict = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments
                                                       error:NULL];
    }
    
    return resultDict;
}

+ (NSString *)unzipDecodeData:(NSData *)requestData
{
    NSData* gunzippedData = [requestData gzipUnpack];
    
    if(gunzippedData)
    {
        return [[NSString alloc] initWithData:gunzippedData encoding:NSUTF8StringEncoding];
    }
    return @"";
}


+ (NSData *)UIImageExchangeToNSData:(UIImage *)aImage
{
    
    double quality = 1.0;
    NSData *imageData=UIImageJPEGRepresentation(aImage, quality);
    while ([imageData length]>IMAGE_DATASIZE) {
        if(quality>0.1){
            quality-=0.1;
            imageData=UIImageJPEGRepresentation(aImage, quality);
        }else{
            imageData=UIImageJPEGRepresentation(aImage, 0);
            break;
        }
    }
    return  imageData;
}


@end
