
import '../model/route_model.dart';

final allRoutes = <RouteModel>[
  // const RouteModel(
  //     id: "a82f995a-04bc-47ad-4391-08d9d52615b5",
  //     name: "X2",
  //     area: "Salmiya,Salmiya Club,GAD Rest.,Khansa St.,Al Aman Indian School,Mughira St.,Apollo Hospt.,3rd Ring Rd,Shaab Park,Promenade Mall,Maidan Hawally,Baghdad St.,Al Sadiq Round-About,Tunis St.,Canary Rest.,Royal Hayat Hospital,4th Ring Rd.,Hawally Traffic Dept.,Rd No. 50,Airport",
  //     from_To: "Salmiya to Airport",
  //     company: "CityBus" ),
  // const RouteModel(
  //     id: "7c03d795-949b-4d35-4392-08d9d52615b5",
  //     name: "X3",
  //     area: "Bneid Al Gar, Al Kharafi St.,Al Salam Intl Hospital,Dasman,Al Shuhada St.,Ahmad Al Jaber St.,Sharq, Mirqab,JW Marriot Hotel,Fahad Salem St.,Maliya,1st Ring Rd.,Road No. 50,Riyadh Rd.,Khaldiya University,5th Ring Rd.,Airport Rd No. 55,Kuwait Zoo,Farwaniyah Stadium,Crowne Plaza,Holiday Inn,Airport",
  //     from_To: "Bneid Al Gar to Airport",
  //     company: "CityBus"),
  // const RouteModel(
  //     id: "952a60e4-688b-48bf-4393-08d9d52615b5",
  //     name: "X4",
  //     area: "Riggae, Ramada Hotel,Al Omooma Hospital,Al Dallah Supermarket,5th Rind Rd.,Avenues,Rabia,Ghazali Rd. 60,Ali Fahad Al Dewailah St. 200,Farwaniyah Co-Op,Farwaniyah Police Station,Habeeb Munawer St.,Metro Farwaniyah,Crowne Plaza,Holiday Inn,Abu Dabhi St.,Ibrahim Bin Adham St.,Khaitan,Khaitan Park,Bin Zuhair St.,American School,Awtad Complex,Muscat St.,Khaitan Police Station,Airport Rd. 55,Airport",
  //     from_To: "Riggae to Airport",
  //     company: "CityBus"),
  // const RouteModel(
  //     id: "ee15b120-a8ec-4c0e-7fd3-08d9d5a7526e",
  //     name: "11",
  //     area: "Shuhada St., Sharq, Ahmed Al Jaber St., Dasman Round-About, Sharq Police Station, Darwazah, Mirqab, Safat Square, Fahad Al Salem St., Muthana Complex, Maliya, Sheraton Hotel, Jahra Rd 80, 2nd Ring Rd., Jamal Abdul Nasser St., Kuwait Flour Mill, Shuwaikh Port, Kuwait University, Sabha Hospitals, Al Razi Orthopedic Hospital, Ministry of Social Affairs, Un Circle, Jahra Rd 80, Nahdha, Sulaibhikat, Al Mahraqa Rd., Amghara Industrial Area, Amghara Grocery, KPTC Garage",
  //     from_To: "Sharq - Maliya - Port - Sabha - UN Circle - Sulaibhikat - Amghara",
  //     company: "CityBus" ),
  // RouteModel(
  //     id: "59e8e389-8bc6-4270-7fd4-08d9d5a7526e",
  //     name: "12",
  //     area: "Shuhada St.,Sharq,Ahmed Al Jaber St.,Dasman Round-About,Sharq Police Station,Darwazah,Mirqab,Safat Square,Abdulla Al Mubarak St.,Gulf Rose Hotel,Abdulaziz Hamad Al Saqer St., Liberation Tower,JW Marriott,Muthana Complex,Fahad Al Salem St.,Maliya,Jahra Rd 80,City Centre Shuwaikh,Aiport Rd 55,Kuwait University,4th Ring Rd,Safat Alghanim,Rd 601,Al Omooma Hospital,Riggai,4th Ring Rd.,UN Round-About,Jahra Rd 80,Al Andalous Clinic,Al Andalous,Firdous,Ardiyah Central,Sabah Al Nasser,The Sultan Center,Sulaibiya,Al Sulaibiya Industrial Area.",
  //     from_To: "Sharq - Maliya - Riggai - UN Circle - Andalous - Sabah Al Nasser - Sulaibiya",
  //     company: "CityBus"),
  RouteModel(
      id: "05f9e3d0-2b28-4180-7fd5-08d9d5a7526e",
      name: "13",
      area: "Mirqab,Educational Science Museum,Fahad Al Salem St.,Muthana Complex,Maliya,Jahra Rd 80,2nd Ring Rd.,Jamal Abdul Nasser St.,Kuwait Flour Mill,Airport Rd 55,City Center Shuwaikh,Kuwait University,Khaldiya,Lulu Hypermarket Alrai,Friday Market,Kuwait Zoo,Omariya,Muscat St.,Khaitan Police Station,Osaimi Hospital,Awtad Complex,Bin Zuhair St.,American School Khaitan,Khaitan Garden,Khaitan Health Insurance,Khaitan Clinic,Abu Dabhi St.,Holyday Inn Farwaniyah,Crown Plaza,Airpot Rd 55,Ghazali Rd 60,Airport",
      from_To: "Mirqab - Maliya - Alrai Lulu - Friday Market - Khaitan - Holyday Inn Farwaniyah - Airport",
      company: "CityBus"),
  // RouteModel(
  //     id: "590cb933-9127-4a42-e5bc-08d9d5c55b4d",
  //     name: "14",
  //     area: "Mirqab,Darwazah,Mubarak Al Kabeer St.,Awqat Tower, Cairo St.,Shaab Round-About,Jawallah Club,Salmiya Garden,Balajat St.,Messila",
  //     from_To: "Mirqab - Messila",
  //     company: "CityBus"),
  RouteModel(

      id: "8205da6c-2508-4ed2-d459-08d9d5cd956f",
      name: "21",
      area: "Mirqab, Science Museum, Fahad Al Salem St., Maliya, Jahra Rd, Kuwait Sports Club, City Center, Airport Rd, Lulu, Khaldiya Rd 55, Omariya, Farwaniya Fire Station, Farwaniyah Co-Op, Metro, Holiday Inn Farwaniyah, Dajeej, Jleeb Co-Op, Abbassiya, German Clinic, Jleeb Round-About",
      from_To: "Mirqab to Jleeb",
      company: "CityBus"),
  RouteModel(
      id: "b0050d7e-480a-4bec-fb85-08d9d65b80a8",
      name: "506",
      area: "Hassawi, 6th Ring Rd, Holiday Inn, Farwaniyah Co-Op, South Khaitan, Airport Rd, 4th Ring Rd, Tunis Street, 3Rd Ring Rd, Istiqlal St., Embassies, Soor St., Darwaza, Fahad Al Salem St., Maliya",
      from_To: "Jleeb to Maliya",
      company: "CityBus"),
  RouteModel(
      id: "49bce42e-722b-4f56-13a7-08d9d82ee213",
      name: "15",
      area: "Sheraton, Maliya, Al Muthanna Complex, JW Marriott, Liberation Tower, Mirqab, Sharq, Darwazah, Mubarak Al Kabeer St., Al Shuhada St., Mazaya Tower, KBT Tower, Istiqlal St., Bneid Al Qar, Dasma, Embassies, 30 Rd, Daiya, Shaab, Qadsiya Sports Club, Maidan Hawally, 4th Ring Rd, Salmiya Fire Station, Amman St., Apollo Hospital, MOE, Al Mugirah St., Hamad Al Mubarak St., Boulevard, Qatar St., Salem Al Mubarak St., Al Fanar Mall, Centrepoint Salmiya, Sultan Center, Laila Complex, Kuwait Palace Hotel, Cinescape Plaza Cinema, American University of Kuwait, Holiday Inn, French School, Salmiya",
      from_To: "Maliya - Mirqab - Embassies - Daiya - Shaab - Maidan Hawally - Salmiya",
      company: "CityBus"),
  RouteModel(
      id: "34addb01-2b86-49f2-13a8-08d9d82ee213",
      name: "16",
      area: "Sheraton, Maliya, Fahad Al Salem St., Al Muthanna Complex, Safat Square, Mirqab, Darwazah, Mubarak Al Kabeer St., Kipco Tower, Al Shuhada St., Al Hamra Tower, Sharq, Jaber Al Mubarak St., Istiqlal St., Bneid Al Qar, Dasma, Embassies, 30 Rd, Daiya, 3rd Ring Rd, Al Shaab Park, MOC Hawalli, Dar Al Shifa Hospital, Tunisia St., Rehab Complex, Al Bahar, 4th Ring Rd, Royal Hayat Hospital, Rawda, Adaliya, Qortuba, Riyad Rd 50, Yarmouk, Khaitan Sports Club, Khaitan Garden, Khaitan Health Insurance, Khaitan Clinic, Abu Dabhi St., Aiport Rd 55, Holyday Inn Farwaniyah, Crown Plaza, 6th Rind Rd, Dajeej, Dajeej Lulu, Jleeb Mujamma, Jleeb Co-Op, Abbassiya, Jleeb Police Station, Royal City Clinic, German Clinic, Canary, Jleeb Round-About",
      from_To: "Maliya to Khaitan to Jleeb",
      company: "CityBus"),
  // RouteModel(
  //     id: "13d0262e-bb5c-4277-13a9-08d9d82ee213",
  //     name: "17",
  //     area: "Sharq, Sharq Police Station, Darwazah, Riyadh St., Faiha Co-Op, Adaliya Co-Op, Rawda, North Nugra Complex, Hawally, Mubarak Hospital, 4th Ring Rd, Salmiya Fire Station, Salmiya Garden",
  //   from_To: "Sharq to Salmiya",
  //     company: "CityBus",),
  // RouteModel(
  //     id: "78e9a9fd-52f7-462d-13aa-08d9d82ee213",
  //     name: "18",
  //     area: "Mirqab, Darwazah, Cairo St., Tunis St., Dowra Sadiq Hawalli, 4th Ring Rd., Royal Hayat, Airport Rd 55, Canada Dry St., Toyota Spare Parts, Shuwaikh Sabah Hospitals, UN Circle",
  //     from_To: "Mirqab to UN Circle",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "2b7207b0-3550-4f1f-13ab-08d9d82ee213",
  //     name: "19",
  //     area: "UN Circle, Sabah Hospitals, 601 Rd, Shahrazad Roundabout, Canada Dry St., Toyota Spare Parts, Mc Donald's, 3 rd Ring Rd, Plaza Complex Hawally, Beirut St., Dar Al Shifa Hospital, Tunis St., Best Al Yousifi, Al Bahar Center, 4th Ring Rd, Salmiya Fire Station, Amman St., Apollo Pharmacy, Al Mughira Bin Shu'ba St., Boulevard Park, Salmiya Park, Al Amal Indian School, Al Khansa St., Holyday Inn Salmiya",
  //     from_To: "UN Circle to Salmiya",
  //     company: "CityBus"),
  RouteModel(
      id: "fe93a64c-f498-4089-13ad-08d9d82ee213",
      name: "21A",
      area: "Sharq, Darwaza, Fahad Al Salem St., Maliya, Jahra Rd, Kuwait Sports Club, City Center, Airport Rd, Lulu, Khaldiya Rd 55, Omariya, Farwaniya Fire Station, Farwaniyah Co-Op, Metro, Farwaniyah",
      from_To: "Sharq to Farwaniyah",
      company: "CityBus"),
  // RouteModel(
  //     id: "ab725dd3-8a0f-45bb-13ae-08d9d82ee213",
  //     name: "23",
  //     area: "Mirqab, Liberation Tower, Muthanna Complex, Maliya, Soor St., 50 Rd, King Faisal Road, Riyadh Rd, Khaldia, 5th Ring Rd, Kuwait Zoo, 55 Rd, Khaitan Police Station, Muscat St., American School, Khaitan Garden, Khaitan Clinic, Holiday Inn Farwaniyah, Subhan",
  //     from_To: "Mirqab to Khaitan to Subhan",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "350cf099-a822-4aa8-13b0-08d9d82ee213",
  //     name: "24",
  //     area: "Mirqab, Darwazah, Mubarak Al Kabeer St., Soor St., 40 Rd., 2nd Ring Rd., Qadisiya Coop, 3 rd Ring Rd., Khaldoun St. Hawalli, Beirut St., Tunis St., 4th Ring Rd., Salmiya Fire Station, Amman St., 5th Ring Rd., Rumaithiya, Ta'awan St., Messila",
  //     from_To: "Mirqab to Salmiya to Messila",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "7b5731da-6263-40da-13b1-08d9d82ee213",
  //     name: "25",
  //     area: "Jabriya, Hawalli, Jahra Gate",
  //     from_To: "Jabriya to Jahra",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "876046f7-6036-4f5f-13b2-08d9d82ee213",
  //     name: "26",
  //     area: "Sharq, Dasman, Fahad Al Salem St., Maliya, Airport Rd, Kuwait Club, Canada Dry St., UN Round-About, Andalus, Firdoous Co-Op, Sabah Al Naser Co-Op, Sulaibiya",
  //     from_To: "Sharq to Sulaibiya",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "615196b5-0878-4bc6-13b3-08d9d82ee213",
  //     name: "34",
  //     area: "UN Circle, Sabah Hospitals, 601 Rd, Shahrazad Roundabout, Canada Dry St., Toyota Spare Parts, Mc Donald's, Airport Rd 55, Al-Rai Lulu, Friday Market, Omariya, Farwaniyah Fire Station, Farwaniyah Coop, Metro Complex, Holiday Inn Farwaniyah, Khaitan, 50 Rd, 360 Mall, Civil ID Office (PACI), 6th Ring Rd, Messila, 30 Rd, Salwa Coop, Bidea Round About, Al Seef Hospital, Al Blajat St., Salmiya",
  //     from_To: "UN Circle to Civil ID Office to Salmiya",
  //     company: "CityBus"),
  // RouteModel(
  //     id: "adcea9d9-75de-41d6-e1cb-08d9d8e06e59",
  //     name: "101",
  //     area: "Mirqab, Maliya, Jahra Rd, City Center, Airport Rd, Lulu, 6th Ring Rd, Holiday Inn Farwaniyah, South Surra, Civil ID Office (PACI), Sabah Al Salem, Qurain, West Fintas, Al Sabahiya, Mecca St., Daboos St., Fahaheel",
  //     from_To: "Mirqab Civil ID Office to Fahaheel",
  //     company: "CityBus"),
      RouteModel(
          id: "eeea236d-1ead-4df6-e1cc-08d9d8e06e59",
          name: "102",
          area: "Maliya, Municipality Garden, Bank District, Flex Gym, Embassies, Daiya, Khaldoun St., Cairo St., Hadi Clinic, Bayan, Mishref, Salwa, Messila, Sabah Al Salem, Funaitees, Egaila, Fintas, Mahaboula, Abu Halifa, Hel Sports Club, Indian Internal School, Fahaheel Sports Club, Niaf Chicken, Fahaheel Central Market, All Mulla, Fahaheel",
          from_To: "Maliya to Fahaheel",
          company: "CityBus"),
  RouteModel(
      id: "75a18536-0c69-43a4-a7fa-08d9d8e52084",
      name: "102X",
      area: "Maliya, Municipality Garden, Bank District, Flex Gym, Embassies, Daiya, Khaldoun St., Cairo St., Hadi Clinic, Bayan, Mishref, Salwa, Messila, Sabah Al Salem, Funaitees, Egaila, Fintas, Mahaboula, Abu Halifa, Hel Sports Club, Indian Internal School, Fahaheel Sports Club, Niaf Chicken, Fahaheel Central Market, All Mulla, Fahaheel",
      from_To: "Maliya To Fahaheel",
      company: "CityBus"),
  // RouteModel(
  //     id: "92b6e23f-27d0-46aa-a871-08d9e6387205",
  //     name: "38",
  //     area: "Maliya, Fahad Al Salem St., Darwazah, Mubarak Al Kabeer St., Shuhada St., Istiqlal, 3 rd Ring Rd., Tunis St., Canary Hawally, Jabriya Coop, Bayan Coop, Mishref Coop, Da'ahiya Sabah Al Salem",
  //     from_To: "Maliya to Da'ahiya",
  //     company: "CityBus"),
  RouteModel(
      id: "72217bca-dd3c-4f28-a872-08d9e6387205",
      name: "39 39A",
      area: "Sharq, Mirqab, Maliya, City Center, Lulu, Airport Rd, 4th Ring Rd, Plant Nurseries, Shuwaikh Fire Station, National Guard Super Market, Riggai, Ardiya, Firdous Co-Op, Farwaniya Hospital, Hassawi, Jleeb Round-About, German Clinic, Abbassiya, Jleeb Co-Op, Ghazali Rd, Farwaniya Co-Op, Khaitan, Subhan",
      from_To: "Sharq to Jleeb to Khaitan to Subhan",
      company: "CityBus"),
  // RouteModel(
  //     id: "f6eacbb0-e2d2-4797-a873-08d9e6387205",
  //     name: "40",
  //     area: "Sharq, Maliya, Airport Rd, Shuwaikh, Khaitan, Jleeb, Farwaniya, Subhan, Fahaheel",
  //     from_To: "Sharq to Fahaheel",
  //     company: "CityBus"),
  RouteModel(
      id: "83235125-1679-40d8-a874-08d9e6387205",
      name: "40A",
      area: "UN Circle, Shuwaikh, Ghazali, Farwaniyah, Khaitan, Subhan, Qurain, Egaila, Fintas, Abu Halifa, Fahaheel",
      from_To: "UN Circle to Fahaheel",
      company: "CityBus"),
  // RouteModel(
  //     id: "0a9798c4-0daf-478f-a875-08d9e6387205",
  //     name: "41",
  //     area: "UN Circle, Jamal Abdul Nasser St., Mohd Bin Qasim Street, Al Rai, Ghazali, Farwaniyah, Khaitan",
  //     from_To: "UN Circle to Khaitan",
  //     company: "CityBus"),

  RouteModel(
      id: "33eaa693-eeb1-4d0d-a876-08d9e6387205",
      name: "44",
      area: "Sharq, Maliya, City Center, 3rd Ring Rd, Canada Dry St., Al-Watan, National Guard HQ, Farwaniyah, Farwaniyah Co-Op, Metro, Khaitan, Pepsi Co, Al-Baqli, Subhan Hospital, Kuwait Flour Mills, ABC Co, Subhan",
      from_To: "Sharq to Subhan",
      company: "CityBus"),
  const RouteModel(
      id: "886bb886-7c78-4eee-a877-08d9e6387205",
      name: "51",
      area: "Sharq, Mirqab, Fahad Al Salem St., Maliya, Jahra Rd, City Center, Airport Rd, Lulu, Khaldiya Rd 55, Holiday Inn Farwaniyah, Dajeej, Jleeb Co-Op, Abbassiya, German Clinic, Jleeb Round-About",
      from_To: "Sharq to Jleeb",
      company: "CityBus"),
  const RouteModel(
      id: "d7c24f28-5f61-4a3b-a878-08d9e6387205",
      name: "55",
      area: "Maliya, Municipality Garden, Bank District, Flex Gym, Embassies, Daiya, Al Rawda, Hawalli, Rehab Complex, Al Bahar, Apollo Hospital, Salmiya Co-Op, Salmiya Sports, Salmiya",
      from_To: "Maliya to Salmiya",
      company: "CityBus"),
  const RouteModel(
      id: "c06b048c-e4ec-4860-a879-08d9e6387205",
      name: "59",
      area: "Mirqab, Science Museum, Municipal Garden, Maliya, Shamiya Entrance, Kuwait Sports Club, City Center, Canada Dry St., Al Watan, Toyota Spare Parts, Center Point Al Rai, Ardiya Industrial Area, Rabya, Al Nasar Sports Club, Hassawi, Bayan Pharmacy, Jleeb Round-About",
      from_To: "Mirqab to Hassawi",
      company: "CityBus"),
  const RouteModel(
      id: "1e63ec27-af99-440b-a87a-08d9e6387205",
      name: "66",
      area: "Salmiya, Sultan Center, Zahra Complex, Shaab Park, Al Bahar, Rehab Complex, Hawally Eng School, Qortuba, 4th Ring Rd, Lulu, Friday Market, Farwaniya Fire Station, Farwaniya Co-Op, Holiday Inn, 6th Ring Rd, Dajeej, Hassawi",
      from_To: "Salmiya to Hassawi",
      company: "CityBus"),

  const RouteModel(
      id: "80b4d560-316d-409f-a87b-08d9e6387205",
      name: "66X",
      area: "Salmiya, Al Mughira St., Qortuba, 4th Ring Rd, Lulu, Friday Market, Farwaniya Fire Station, Farwaniya Co-Op, Holiday Inn, 6th Ring Rd, Dajeej, Hassawi",
      from_To: "Salmiya to Hassawi",
      company: "CityBus"),
  const RouteModel(
      id: "7461946d-fb40-42e1-a87c-08d9e6387205",
      name: "77",
      area: "Salmiya, Salmiya Sports, Salmiya Co-Op, Apollo Hospital, Al Bahar, Rehab, Dar Al Shifa Hospital, MOC Hawally, Nugra, 3rd Ring Rd, Adaliya, PAEET Headquarters, Canada Dry St., Al Watan, Toyota Spare Parts, London Shopping, Al Naki, Sultan Center, Safat Alghanim, Lulu, Khaitan Police Station, Awtad Mall, Khaitan Garden, Khaitan",
      from_To: "Salmiya to Khaitan",
      company: "CityBus"),
  const RouteModel(
      id: "b7070ee2-96e9-4759-a87d-08d9e6387205",
      name: "77X",
      area: "Salmiya, Salmiya Khansa St., Qatar St., Mughira, Apollo Hospital, 4th Ring Road, Shuwaikh, Canada Dry St., 4th Ring Road, Riggae, Ardiya",
      from_To: "Salmiya to Ardiya",
      company: "CityBus"),
  // const RouteModel(
  //     id: "9b57f6e6-626f-4607-a87e-08d9e6387205",
  //     name: "88",
  //     area: "Salmiya, Gad Rest., Apollo Hospital, Shaab Park, Rehab Complex, Al Rawda Co-Op, Al Sadiq Round-About, Rawda, Adaliya, 4th Ring Rd, Al Watan, Canada Dry St., Toyota Spare, Al Naki, Sultan Center, Safat Alghanim, Al Rai, Center Point, 60 Rd, 6th Ring Rd, Jleeb Co-Op, Abbassiya, German Clinic, Jleeb Round About",
  //     from_To: "Salmiya to Jleeb",
  //     company: "CityBus"),
  //
  // const RouteModel(
  //     id: "6af5fc4e-873a-4e74-a87f-08d9e6387205",
  //     name: "99",
  //     area: "Airport, Jleeb Co-Op, Abbassiya, German Clinic, Jleeb Round-About, Hassawi, Rabya, Ardiya Industrial Area, National Guard HQ, Toyota Spare, Canada Dry St., Al Watan, Lulu, Friday Market, Farwaniyah Fire Station, Farwaniyah Co-Op, Holiday Inn, Khaitan, Al Zahra, South Surra, Civil ID Office (PACI)",
  //     from_To: "Airport to Jleeb to Civil ID Office",
  //     company: "CityBus"),
  const RouteModel(
      id: "4ffcc1f8-0be9-4a89-a880-08d9e6387205",
      name: "103",
      area: "Mirqab, Fahad Al Salem St., Maliya, Jahra Rd, City Center, Al Tilal Complex, Ghazali Bridge, Risco, Army General HQ, Traffic Dept., KGL PT Office, UN Circle, Infectious Diseases Hospital, Andalous, Sulaibhikat, Doha, Amghara Camp, 80 Rd, Jahra Sports, Jahra Round-About, Kuwait Flour Mill, Jahra Co-Op, MOC Jahra",
      from_To: "Mirqab to Jahra",
      company: "CityBus"),
  // const RouteModel(
  //     id: "dd5e180d-24a9-4634-a881-08d9e6387205",
  //     name: "105",
  //     area: "Fahaheel, Mecca Street, Mangaf, Abu Halifa, Coastal Rd, Al Aqeela, Qurain, Daayia Sabah Al Salem, South Surra, PACI (Civil ID Office), 6th Ring Rd, New Khaitan, Canada Dry St., Hassawi",
  //     from_To: "Fahaheel to Hassawi",
  //     company: "CityBus"),
  // const RouteModel(
  //     id: "69eda6de-0f61-4d4e-a882-08d9e6387205",
  //     name: "105A",
  //     area: "Fahaheel, Abu Halifa, Mangaf, Mahaboula, Fintas, Sabah Al Salem, Khaitan, Lulu, Canada Dry St., Hassawi",
  //     from_To: "Fahaheel to Hassawi",
  //     company: "CityBus"),

  const RouteModel(
      id: "86baaa34-5568-4e98-a883-08d9e6387205",
      name: "106",
      area: "Hassawi, Jleeb Round-About, German Clinic, Abbassiya, Jleeb Co-Op, 6th Ring Rd, 60 Rd, Farwaniyah Co-Op, Metro, Holiday Inn, Khaitan, Al Zahra, South Surra, Civil ID Office (PACI), 360 Mall, Messila, Sabah Al Salem, Funaitees, Egaila, Fintas, Mahaboula, Abu Halifa, Fahaheel",
      from_To: "Jleeb to Civil ID Office to Fahaheel",
      company: "CityBus"),
  const RouteModel(
      id: "c886c374-ea70-46b1-a884-08d9e6387205",
      name: "106X",
      area: "Hassawi, Jleeb Round-About, German Clinic, Abbassiya, Jleeb Co-Op, 6th Ring Rd, 60 Rd, Farwaniyah Co-Op, Metro, Holiday Inn, Khaitan, Messila, Sabah Al Salem, Funaitees, Egaila, Fintas, Mahaboula, Abu Halifa, Fahaheel",
      from_To: "Jleeb to Fahaheel",
      company: "CityBus"),
  // const RouteModel(
  //     id: "c0886d50-e396-4539-a886-08d9e6387205",
  //     name: "205",
  //     area: "Fahaheel, Souk Fahaheel, King Abdul Aziz Bin Abdul Rehman Rd., St. 220, Connecting Kheiran & Al-Zour Block 7 right parallel to Chalet, St. 270, King Fahad Rd., St. 285, King Fahad Bin Abdul Aziz Rd., Beneidar",
  //     from_To: "Fahaheel to Beneidar",
  //     company: "CityBus"),
  // const RouteModel(
  //     id: "610b799f-c075-4e44-a887-08d9e6387205",
  //     name: "500",
  //     area: "KPTC Bus Depot (Hasawi), 602 Rd., Farwaniya Hospital, 6th Ring Rd., Kuwait Shooting Federation, Doha Rd., Jahra Road (80 No. road), Trolley Convenience Store, Mutlaa Police Station, New Abdaly Supermarket, Abdaly",
  //     from_To: "Jleeb to Abdaly",
  //     company: "CityBus"),
  const RouteModel(
      id: "02104774-681e-4068-a88e-08d9e6387205",
      name: "747",
      area: "Hassawi, Jleeb Round-About, German Clinic, Abbassiya, 100 Rd, Airport, Farwaniyah",
      from_To: "Hassawi to Jleeb to Airport (Farwaniyah to Airport)",
      company: "CityBus"),


  //
  const RouteModel(
      id: "2b062ac1-77f3-49e7-a88f-08d9e6387205",
      name: "999",
      area: "Maliya, Al Muthana Complex, Bank Street, Darwaza, Al Hamra Tower, Flex Gym, Istiqlal St., Embassies, Shaab Park, Apollo Hospital, Boulevard Park, Salmiya Sports Club, Salmiya Co-Op, Kuwait Karate Fed., Holiday Inn, Al Seef Hospital, Shaikha Complex, Al Bedda Round-About, Movenpick,Radisson, Bubyan Club, Salwa, Messila, Sabah Al Salem, Egaila, Fintas, Kuwait Magic Mall, Abu Halifa, Mangaf, Fahaheel - Green Tower",
      from_To: "Maliya to Fahaheel",
      company: "CityBus"

  ),
  const RouteModel(
      id: "f7eeabe8-c9c6-4024-a88b-08d9e6387205",
      name: "507",
      area: "Mirqab, Fahad Al Salem St., Maliya, Jahra Rd, City Center, Airport Rd, Al Watan, Canada Dry St., Toyota Spare, Al Naki, Sultan Center, Safat Alghanim, Al Rai, Center Point, 60 Rd, 6th Ring Rd, Jleeb Co-Op, Abbassiya, German Clinic, Jleeb Round About",
      from_To: "Sharq to Jleeb",
      company: "CityBus"
  ),

  const RouteModel(
      id: "d9213729-1e61-41e2-a890-08d9e6387205",
      name: "X1",
      area: "Fahaheel, Central, Hilton Hotel, Sultan Center Mangaf, Abu Halifa Co-Op, Mahboula, Lulu Exchange, Aliya Hospital, Fintas, London Hospital, Fintas Police Station, Fintas Co-Op, Egaila, Mubarak Al Kabeer, Airport",
      from_To: "Fahaheel to Airport",
      company: "CityBus"
  ),
  const RouteModel(
      id: "3abd5547-ac72-43d7-9e38-08da10932498",
      name: "59X",
      area: "Shuwaikh , Hassawi",
      from_To: "Shuwaikh to Hassawi",
      company: "CityBus"
  ),
  const RouteModel(
      id: "555bbe2f-74c2-4ed2-98ec-08da16ed983b",
      name: "77",
      area: "Salmiya, Salmiya Sports, Salmiya Co-Op, Apollo Hospital, Al Bahar, Rehab, Dar Al Shifa Hospital, MOC Hawally, Nugra, 3rd Ring Rd, Adaliya, PAEET Headquarters, Canada Dry St., Al Watan, Toyota Spare Parts, London Shopping, Al Naki, Sultan Center, Safat Alghanim, Lulu, Khaitan Police Station, Awtad Mall, Khaitan Garden, Khaitan",
      from_To: "Salmiya to Khaitan",
      company: "a"
  ),
  const RouteModel(
      id: "b4d92978-449e-47e5-1b5b-08da1c704203",
      name: "44",
      area: "Sharq, Maliya, City Center, 3rd Ring Rd, Canada Dry St., Al-Watan, National Guard HQ, Farwaniyah, Farwaniyah Co-Op, Metro, Khaitan, Pepsi Co, Al-Baqli, Subhan Hospital, Kuwait Flour Mills, ABC Co, Subhan",
      from_To: "Sharq to Subhan",
      company: "CityBus"
  ),
  const RouteModel(
      id: "02104774-681e-4068-a88e-08d9e6387205",
      name: "747",
      area: "Hassawi, Jleeb Round-About, German Clinic, Abbassiya, 100 Rd, Airport, Farwaniyah",
      from_To: "Hassawi to Jleeb to Airport (Farwaniyah to Airport)",
      company: "CityBus"),



];
