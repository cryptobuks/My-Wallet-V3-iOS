//
//  BackupViewController.swift
//  Blockchain
//
//  Created by Sjors Provoost on 19-05-15.
//  Copyright (c) 2015 Blockchain Luxembourg S.A. All rights reserved.
//

import UIKit

class BackupViewController: UIViewController, TransferAllPromptDelegate {
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var backupWalletButton: UIButton!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var backupIconImageView: UIImageView!
    @IBOutlet weak var backupWalletAgainButton: UIButton!
    @IBOutlet weak var lostRecoveryPhraseLabel: UILabel!
    
    var wallet : Wallet?
    var app : RootService?
    var transferredAll = false;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backupWalletButton.setTitle(NSLocalizedString("BACKUP FUNDS", comment: ""), for: UIControlState())
        backupWalletButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backupWalletButton.contentHorizontalAlignment = .center
        backupWalletButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        backupWalletButton.clipsToBounds = true
        backupWalletButton.layer.cornerRadius = Constants.Measurements.BackupButtonCornerRadius
        
        if wallet!.isRecoveryPhraseVerified() {
            summaryLabel.text = NSLocalizedString("You backed up your funds successfully.", comment: "");
            explanation.text = NSLocalizedString("Well done! Should you lose your password, you can restore funds in this wallet even if received in the future (except imported addresses) using the 12 word recovery phrase. Remember to keep your Recovery Phrase offline somewhere very safe and secure. Anyone with access to your Recovery Phrase has access to your bitcoin.", comment: "")
            backupIconImageView.image = UIImage(named: "thumbs")
            backupWalletButton.setTitle(NSLocalizedString("VERIFY BACKUP", comment: ""), for: UIControlState())
            backupWalletAgainButton.isHidden = false
            backupWalletAgainButton.titleLabel?.textAlignment = .center;
            backupWalletAgainButton.titleLabel?.adjustsFontSizeToFitWidth = true;
            lostRecoveryPhraseLabel.isHidden = false
            lostRecoveryPhraseLabel.adjustsFontSizeToFitWidth = true;
            lostRecoveryPhraseLabel.textAlignment = .center;
            
            // Override any font changes
            backupWalletAgainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14);
            lostRecoveryPhraseLabel.font = UIFont.boldSystemFont(ofSize: 14);
            
            if (wallet!.didUpgradeToHd() && wallet!.getTotalBalanceForSpendableActiveLegacyAddresses() >= wallet!.dust() && navigationController!.visibleViewController == self && !transferredAll) {
                let alertToTransferAll = UIAlertController(title: NSLocalizedString("Transfer imported addresses?", comment:""), message: NSLocalizedString("Imported addresses are not backed up by your Recovery Phrase. To secure these funds, we recommend transferring these balances to include in your backup.", comment:""), preferredStyle: .alert)
                alertToTransferAll.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment:""), style: .cancel, handler: nil))
                alertToTransferAll.addAction(UIAlertAction(title: NSLocalizedString("Transfer all", comment:""), style: .default, handler: { void in
                    let transferAllController = TransferAllFundsViewController()
                    transferAllController.delegate = self;
                    let navigationController = BCNavigationController(rootViewController: transferAllController, title: NSLocalizedString("Transfer All Funds", comment:""))
                    self.app?.transferAllFundsModalController = transferAllController
                    self.present(navigationController!, animated: true, completion: nil)
                }))
                present(alertToTransferAll, animated: true, completion: nil)
            }
        }
        
        explanation.sizeToFit();
        explanation.center = CGPoint(x: view.frame.width/2, y: explanation.center.y)
        changeYPosition(explanation.frame.origin.y + explanation.frame.size.height + 20, view: backupWalletButton)
        changeYPosition(backupWalletButton.frame.origin.y + backupWalletButton.frame.size.height + 20, view: lostRecoveryPhraseLabel)
        changeYPosition(lostRecoveryPhraseLabel.frame.origin.y + 10, view: backupWalletAgainButton)
        
        if (backupWalletAgainButton.frame.origin.y + backupWalletAgainButton.frame.size.height > view.frame.size.height) {
            changeYPosition(view.frame.size.height - backupWalletAgainButton.frame.size.height, view: backupWalletAgainButton)
            changeYPosition(backupWalletAgainButton.frame.origin.y - 10, view: lostRecoveryPhraseLabel)
            changeYPosition(lostRecoveryPhraseLabel.frame.origin.y - backupWalletAgainButton.frame.size.height - 20, view: backupWalletButton)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        transferredAll = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (backupWalletAgainButton?.isHidden == false) {
            backupWalletButton?.setTitle(NSLocalizedString("VERIFY BACKUP", comment: ""), for: UIControlState())
        } else {
            backupWalletButton?.setTitle(NSLocalizedString("BACKUP FUNDS", comment: ""), for: UIControlState())
        }
    }
    
    func changeYPosition(_ newY: CGFloat, view: UIView) {
        view.frame = CGRect(x: view.frame.origin.x, y: newY, width: view.frame.size.width, height: view.frame.size.height);
    }
    
    @IBAction func backupWalletButtonTapped(_ sender: UIButton) {
        if (backupWalletButton!.titleLabel!.text == NSLocalizedString("VERIFY BACKUP", comment: "")) {
            performSegue(withIdentifier: "verifyBackup", sender: nil)
        } else {
            performSegue(withIdentifier: "backupWords", sender: nil)
        }
    }
    
    @IBAction func backupWalletAgainButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "backupWords", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backupWords" {
            let vc = segue.destination as! BackupWordsViewController
            vc.wallet = wallet
        }
        else if segue.identifier == "verifyBackup" {
            let vc = segue.destination as! BackupVerifyViewController
            vc.wallet = wallet
            vc.isVerifying = true
        }
    }
    
    func didTransferAll() {
        transferredAll = true
    }
    
    func showAlert(_ alert : UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func showSyncingView() {
        let backupNavigation = self.navigationController as? BackupNavigationViewController
        backupNavigation?.busyView?.fadeIn()
    }
}
