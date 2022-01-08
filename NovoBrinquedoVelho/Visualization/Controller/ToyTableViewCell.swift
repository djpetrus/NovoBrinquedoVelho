//
//  ToyTableViewCell.swift
//  NovoBrinquedoVelho
//
//  Created by Petrus Ribeiro Lima da Costa on 02/01/22.
//

import UIKit

class ToyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewToyPhoto: UIImageView!
    @IBOutlet weak var labelToyName: UILabel!
    @IBOutlet weak var labelToyState: UILabel!
    @IBOutlet weak var labelDonorAddres: UILabel!
    @IBOutlet weak var labelDonorTelephone: UILabel!
    @IBOutlet weak var labelDonorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureWith(_ toy: Toy) {
        labelToyName.text = toy.toyName
        labelToyState.text = toy.toyStateName
        if let image = toy.toyPhoto {
            let image64 = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
            imageViewToyPhoto.image = UIImage(data: image64)
        }
        labelDonorAddres.text = toy.donorAddress
        labelDonorTelephone.text = String(toy.donorTelephone)
        labelDonorName.text = toy.donorName
    }

}
