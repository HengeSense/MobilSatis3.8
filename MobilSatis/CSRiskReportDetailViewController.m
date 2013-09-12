//
//  CSFinancialReportDistributorViewController.m
//  MobilSatis
//
//  Created by Ata  Cengiz on 10.05.2013.
//
//

#import "CSRiskReportDetailViewController.h"

@interface CSRiskReportDetailViewController ()

@end

@implementation CSRiskReportDetailViewController
@synthesize distributorFinancialReport;
@synthesize tableView;

- (id)initWithReport:(CSFinancialReport *)i_report
{
    self = [super init];
    
    if (self) {
        distributorFinancialReport = i_report;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = nil;
    
    [[self navigationItem] setTitle:distributorFinancialReport.musteriAdi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    int section = [indexPath section];
    int row = [indexPath row];
    
    cell.textLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:33.0/255.0 blue:88.0/255.0 alpha:1.0];
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    
        switch (row) {
            case 0:
                cell.textLabel.text = @"Toplam Teminat Tutar";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.eTeminatTutar];
                break;
            case 1:
                cell.textLabel.text = @"Banka Güvencesi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.abankTutar];
                break;
            case 2:
                cell.textLabel.text = @"Mal Alma Limiti";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.malLimitTutar];
                break;
            case 3:
                cell.textLabel.text = @"EFPA Kredi Limiti";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.ekLimitTutar];
                break;
            case 4:
                cell.textLabel.text = @"EFPA K.Bilir Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.ekKrediTutar];
                break;
            case 5:
                cell.textLabel.text = @"Banka K.Bilir Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.akKrediTutar];
                break;
            case 6:
                cell.textLabel.text = @"Toplam Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f",[distributorFinancialReport.ekKrediTutar floatValue] + [distributorFinancialReport.akKrediTutar floatValue]]];
                break;
            case 7:
                cell.textLabel.text = @"Toplam K.Kredi";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f", [distributorFinancialReport.ekLimitTutar floatValue] - ([distributorFinancialReport.vglToplamTutar floatValue] + [distributorFinancialReport.vgcToplamTutar floatValue] + [distributorFinancialReport.kanunTakTutar floatValue] + [distributorFinancialReport.acikKalanTutar floatValue]) ]];
                break;
            case 8:
                cell.textLabel.text = @"Toplam C/H Borcu";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:[NSString stringWithFormat:@"%f", [distributorFinancialReport.vglToplamTutar floatValue] + [distributorFinancialReport.vgcToplamTutar floatValue] + [distributorFinancialReport.kanunTakTutar floatValue] + [distributorFinancialReport.acikKalanTutar floatValue]]];
                break;
            case 9:
                cell.textLabel.text = @"V.Gel. Talimat";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.vglTalimatTutar];
                break;
            case 10:
                cell.textLabel.text = @"V.Gel. Çekler";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.vglCekTutar];
                break;
            case 11:
                cell.textLabel.text = @"V.Gel. Toplam";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.vglToplamTutar];
                break;
            case 12:
                cell.textLabel.text = @"V.Geç. Talimat";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.vgcTalimatTutar];
                break;
            case 13:
                cell.textLabel.text = @"V.Geç Toplam";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.vgcToplamTutar];
                break;
            case 14:
                cell.textLabel.text = @"Açık Kalem";
                cell.detailTextLabel.text = [ABHXMLHelper correctNumberValue:distributorFinancialReport.acikKalanTutar];
                break;
            case 15:
                cell.textLabel.text = @"Yeni Siparis Toplam Tutar";
                cell.detailTextLabel.text = distributorFinancialReport.yeniSiparisToplamTutar;
                break;
            default:
                break;
        }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

@end
