namespace :db do
  desc "Seeding data"
  task init_club_type: :environment do
    %w[db:migrate].each do |task|
      Rake::Task[task].invoke
    end
    framgiadn = Organization.find_by name: "Framgia Da Nang"
    framgiahn = Organization.find_by name: "Framgia Ha Noi"
    thethao_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "sport"
    )
    game_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "game"
    )
    giaoduc_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "education"
    )
    amnhac_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "music"
    )
    giaitri_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "entertainment"
    )
    tamsu_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "confidential"
    )
    tiectung_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "junket"
    )
    khac_type_dn = ClubType.create!(
      organization_id: framgiadn.id,
      name: "other"
    )

    thethao_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "sport"
    )
    game_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "game"
    )
    giaoduc_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "education"
    )
    amnhac_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "music"
    )
    giaitri_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "entertainment"
    )
    tamsu_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "confidential"
    )
    tiectung_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "junket"
    )
    khac_type_hn = ClubType.create!(
      organization_id: framgiahn.id,
      name: "other"
    )

    clubs_dn = Club.where(organization_id: 1).pluck(:id, :club_type)
    clubs_hn = Club.where(organization_id: 2).pluck(:id, :club_type)

    clubs_hn.each do |id, style|
      club = Club.find_by id: id
      if style == 1
        club.update_attributes club_type_id: thethao_type_hn.id
      elsif style == 2
        club.update_attributes club_type_id: game_type_hn.id
      elsif style == 3
        club.update_attributes club_type_id: giaoduc_type_hn.id
      elsif style == 4
        club.update_attributes club_type_id: amnhac_type_hn.id
      elsif style == 5
        club.update_attributes club_type_id: giaitri_type_hn.id
      elsif style == 6
        club.update_attributes club_type_id: tamsu_type_hn.id
      elsif style == 7
        club.update_attributes club_type_id: tiectung_type_hn.id
      else
        club.update_attributes club_type_id: khac_type_hn.id
      end
    end

    clubs_dn.each do |id, style|
      club = Club.find_by id: id
      if style == 1
        club.update_attributes club_type_id: thethao_type_dn.id
      elsif style == 2
        club.update_attributes club_type_id: game_type_dn.id
      elsif style == 3
        club.update_attributes club_type_id: giaoduc_type_dn.id
      elsif style == 4
        club.update_attributes club_type_id: amnhac_type_dn.id
      elsif style == 5
        club.update_attributes club_type_id: giaitri_type_dn.id
      elsif style == 6
        club.update_attributes club_type_id: tamsu_type_dn.id
      elsif style == 7
        club.update_attributes club_type_id: tiectung_type_dn.id
      else
        club.update_attributes club_type_id: khac_type_dn.id
      end
    end
  end
end
