class Treatment {
  final String culturalEn;
  final String mechanicalEn;
  final String chemicalEn;
  final String culturalTl;
  final String mechanicalTl;
  final String chemicalTl;
  final String culturalCb;
  final String mechanicalCb;
  final String chemicalCb;

  Treatment({
    required this.culturalEn,
    required this.mechanicalEn,
    required this.chemicalEn,
    required this.culturalTl,
    required this.mechanicalTl,
    required this.chemicalTl,
    required this.culturalCb,
    required this.mechanicalCb,
    required this.chemicalCb,
  });
}

class Recommendation {
  final String name;
  final String descriptionEn;
  final String symptomsEn;
  final String descriptionTl;
  final String symptomsTl;
  final String descriptionCb;
  final String symptomsCb;
  final Treatment treatment;

  Recommendation({
    required this.name,
    required this.descriptionEn,
    required this.symptomsEn,
    required this.descriptionTl,
    required this.symptomsTl,
    required this.descriptionCb,
    required this.symptomsCb,
    required this.treatment,
  });
}

final List<Recommendation> recommendations = [
  Recommendation(
    name: 'Algal Leaf Spot of Jackfruit',
    descriptionEn:
        'Algal leaf spot, also known as green scurf, is a foliar disease caused by algae, primarily affecting tropical and subtropical plants. The main causal organism is typically Cephaleuros virescens, a parasitic green alga.',
    symptomsEn:
        'Algal leaf spot arises from algae generally present in the environment, becoming problematic in favorable conditions. Key factors include:\n'
        'High Humidity and Moisture: Prevalent in humid, moist climates or rainy seasons, where wet foliage promotes algal growth.\n'
        'Warm Temperatures: Most common in tropical and subtropical regions.\n'
        'Plant Stress: Stressed plants due to poor nutrition, insect damage, or other diseases are more susceptible.\n'
        'Poor Air Circulation: Dense planting and lack of air flow increase moisture, aiding disease spread.\n'
        'Leaf Surface: Rough or hairy leaf surfaces support algae colonization.\n'
        'Inadequate Drainage: Poor drainage stresses plants, raising disease risk.\n'
        'Overhead Irrigation: Foliage kept wet for prolonged periods can encourage disease.\n'
        'Contaminated Tools: Although less common, pruning tools can transfer algae.',
    descriptionTl:
        'Ang Algal leaf spot, kilala rin bilang berdeng scurf, ay isang sakit na sanhi ng algae na kadalasang nakakaapekto sa mga tropikal at subtropikal na halaman. Ang pangunahing sanhi ay karaniwang Cephaleuros virescens, isang parasitic green algae.',
    symptomsTl:
        'Ang Algal leaf spot ay sanhi ng algae sa kapaligiran na nagiging problema sa tamang kondisyon. Mga sanhi:\n'
        'Mataas na Humidity at Moisture: Karaniwan sa mahalumigmig at maulan na klima.\n'
        'Mainit na Temperatura: Karaniwan sa tropikal na rehiyon.\n'
        'Stress sa Halaman: Ang mga halaman na kulang sa nutrisyon ay mas apektado.\n'
        'Kulang sa Hangin: Ang siksik na pagtatanim ay nagpapataas ng moisture.\n'
        'Surface ng Dahon: Madaling tubuan ng algae ang magaspang na dahon.\n'
        'Mahinang Drainage: Nagpapataas ng panganib ng sakit.\n'
        'Pag-iwas sa Basang Dahon: Mas matagal na basa ang mga halaman.\n'
        'Contaminated Tools: Ang mga pruning tools ay pwedeng magdala ng algae.',
    descriptionCb:
        'Ang Algal leaf spot, kilala usab nga green scurf, usa ka sakit nga gikan sa algae nga nakaapekto sa mga tropical ug subtropical nga tanum. Ang una nga hinungdan sa kasagaran mao ang Cephaleuros virescens, usa ka parasitic green algae.',
    symptomsCb:
        'Ang Algal leaf spot kay naggikan sa algae nga naa na sa palibot ug nag-problema kung paborable ang kondisyon. Mga hinungdan:\n'
        'Mataas nga Humidity ug Moisture: Kasagaran sa humid ug basa nga klima.\n'
        'Mainit nga Temperatura: Kasagaran sa mga tropical nga lugar.\n'
        'Stress sa Tanum: Ang tanum nga kuwang sa nutrisyon mas prone sa sakit.\n'
        'Kulang sa Hangin: Siksikan nga pagtanum makataas sa moisture.\n'
        'Surface sa Dahon: Algae kasagaran sa magaspang nga dahon.\n'
        'Mahinang Drainage: Nagataas sa risgo sa sakit.\n'
        'Paglikay sa Basang Dahon: Dugay nga basa ang tanum.\n'
        'Contaminated Tools: Ang mga pruning tools mahimo nga makaapas sa algae.',
    treatment: Treatment(
      culturalEn:
          'Ensure proper plant spacing, avoid wet leaves, and regularly clean the area.',
      mechanicalEn:
          'Prune infected areas using sanitized tools to prevent spread.',
      chemicalEn:
          'Apply copper-based fungicides to manage the disease effectively.',
      culturalTl:
          'Siguraduhin ang tamang espasyo ng mga halaman, iwasang mabasa ang mga dahon, at linisin ang paligid.',
      mechanicalTl:
          'Pagputol sa mga apektadong bahagi gamit ang sanitized na mga kagamitan para maiwasan ang pagkalat.',
      chemicalTl:
          'Gumamit ng copper-based na fungicides para sa epektibong pamamahala sa sakit.',
      culturalCb:
          'Siguraduhon ang sakto nga gilay-on sa mga tanum, likayi ang basang mga dahon, ug limpyoha ang palibot.',
      mechanicalCb:
          'Pagputol sa mga apektadong bahin gamit ang sanitized nga mga gamit aron malikayan ang pagkaylap.',
      chemicalCb:
          'Gamit ug copper-based nga fungicides para sa epektibong pagpugong sa sakit.',
    ),
  ),
  Recommendation(
    name: 'Black Spot of Jackfruit',
    descriptionEn:
        'Black rot is a common fungal disease of jackfruit caused by the pathogen Rhizopus artocarpi. It primarily affects young fruits and male inflorescences, leading to significant losses in yield.',
    symptomsEn:
        'Soft, watery brown spots initially appear on the fruit or inflorescence. Over time, black spores and white fungal mycelia grow, causing the fruit to rot, shrink, and sometimes mummify. Infected fruits may fall prematurely.',
    descriptionTl:
        'Ang Black rot ay isang fungal disease ng langka sanhi ng Rhizopus artocarpi. Pangunahing naaapektuhan nito ang mga batang bunga at inflorescences na nagdudulot ng malaking pagkalugi sa ani.',
    symptomsTl:
        'Malambot at kayumangging mga spot sa prutas. Habang tumatagal, lumilitaw ang itim na spores at puting mycelia, na nagiging sanhi ng pagkabulok at pagkahulog ng prutas.',
    descriptionCb:
        'Ang Black rot kay usa ka fungal disease sa nangka nga hinungdan sa Rhizopus artocarpi, makaapekto sa bata nga bunga ug inflorescences nga makadaot sa ani.',
    symptomsCb:
        'Malumo ug brown nga mga spot sa bunga. Mibalik ang itom nga spores ug puti nga fungal nga mycelia, nga naghatag ug pagkahulog sa bunga.',
    treatment: Treatment(
      culturalEn:
          'Prune to improve air circulation. Remove infected fruits and avoid wounding. Intercrop with non-susceptible trees.',
      mechanicalEn: 'Handpick and destroy infected fruits as soon as noticed.',
      chemicalEn:
          'Apply fungicides like carbendazim or mancozeb. Consult local experts for product advice.',
      culturalTl:
          'I-prune ang puno para mapahusay ang sirkulasyon ng hangin. Alisin ang mga infected na prutas, iwasan ang sugat, at mag-intercrop ng hindi madaling tamaan.',
      mechanicalTl:
          'Manu-manong tanggalin ang mga infected na bunga agad-agad.',
      chemicalTl:
          'Gumamit ng fungicides tulad ng carbendazim o mancozeb ayon sa rekomendasyon.',
      culturalCb:
          'Pruning sa tanom aron mapauswag ang air circulation. Kuhaa ang mga infected nga bunga ug likayi ang samad. Intercrop sa dili madali ug masakiton nga tanum.',
      mechanicalCb:
          'Mano-manong kuhaa ug sunoga dayon ang mga apektadong bunga.',
      chemicalCb:
          'Gamit ug fungicides sama sa carbendazim o mancozeb ug konsultaha ang local experts.',
    ),
  ),
];
