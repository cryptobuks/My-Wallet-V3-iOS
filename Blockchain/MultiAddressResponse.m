//
//  API.m
//  Blockchain
//
//  Created by Ben Reeves on 10/01/2012.
//  Copyright (c) 2012 Blockchain Luxembourg S.A. All rights reserved.
//

#import "MultiAddressResponse.h"
#import "RootService.h"
#import "Address.h"
#import "Transaction.h"
#import "Wallet.h"
#import "NSString+SHA256.h"
#import "NSString+URLEncode.h"

@implementation CurrencySymbol
@synthesize code;
@synthesize symbol;
@synthesize name;
@synthesize conversion;
@synthesize symbolappearsAfter;

+(CurrencySymbol*)symbolFromDict:(NSDictionary *)dict {
    CurrencySymbol * symbol = [[CurrencySymbol alloc] init];
    NSDictionary *currencyNames = @{
                                    @"USD": @"U.S. Dollar",
                                    @"EUR": @"Euro",
                                    @"ISK": @"lcelandic Króna",
                                    @"HKD": @"Hong Kong Dollar",
                                    @"TWD": @"New Taiwan Dollar",
                                    @"CHF": @"Swiss Franc",
                                    @"DKK": @"Danish Krone",
                                    @"CLP": @"Chilean, Peso",
                                    @"CAD": @"Canadian Dollar",
                                    @"CNY": @"Chinese Yuan",
                                    @"THB": @"Thai Baht",
                                    @"AUD": @"Australian Dollar",
                                    @"SGD": @"Singapore Dollar",
                                    @"KRW": @"South Korean Won",
                                    @"JPY": @"Japanese Yen",
                                    @"PLN": @"Polish Zloty",
                                    @"GBP": @"Great British Pound",
                                    @"SEK": @"Swedish Krona",
                                    @"NZD": @"New Zealand Dollar",
                                    @"BRL": @"Brazil Real",
                                    @"RUB": @"Russian Ruble"
                                    };
    
    symbol.code = [dict objectForKey:@"code"];
    symbol.symbol = [dict objectForKey:@"symbol"];
    NSNumber *last = [dict objectForKey:@"last"];
    symbol.conversion = [[[(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:SATOSHI] decimalNumberByDividingBy: (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:[last doubleValue]]] stringValue] longLongValue];
    symbol.name = [currencyNames objectForKey:symbol.code];
    symbol.symbolappearsAfter = [[dict objectForKey:@"symbolAppearsAfter"] boolValue];
    
    return symbol;
}

@end

@implementation LatestBlock
@synthesize blockIndex;
@synthesize height;
@synthesize time;


@end

@implementation MultiAddressResponse

@synthesize transactions;
@synthesize total_received;
@synthesize total_sent;
@synthesize final_balance;
@synthesize n_transactions;
@synthesize symbol_local;
@synthesize symbol_btc;


@end

