// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'AccessWatch';

  @override
  String get tabMap => 'Mapa';

  @override
  String get loadingData => 'A carregar os dados da cheia…';

  @override
  String get loadError => 'Não foi possível carregar os dados da cheia.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get eventMozambique2026 => 'Cheia em Moçambique, janeiro de 2026';

  @override
  String floodAreaKm2(String area) {
    return '$area km²';
  }

  @override
  String get depthDry => 'Seco';

  @override
  String get depthShallow => 'Baixa';

  @override
  String get depthMedium => 'Média';

  @override
  String get depthDeep => 'Alta';

  @override
  String get depthUnknown => 'Desconhecida';

  @override
  String get depthEstimateWarning =>
      'A profundidade é uma estimativa, em classes e não em metros exatos. Verifique no terreno.';

  @override
  String get warningsTitle => 'Avisos sobre os dados';

  @override
  String get warnShortNisarBeta => 'As cenas NISAR são dados BETA';

  @override
  String get warnNisarBeta =>
      'As cenas NISAR são produtos BETA, ainda não totalmente calibrados. Trate os resultados como preliminares.';

  @override
  String get warnShortDepotAutoSelected =>
      'Depósito de ajuda selecionado automaticamente: rotas e prioridades são ilustrativas';

  @override
  String get warnDepotAutoSelected =>
      'O depósito de ajuda foi SELECIONADO AUTOMATICAMENTE e não é um depósito real. As rotas e as prioridades são ilustrativas até ser definido o depósito real.';

  @override
  String get warnShortValidationProductOrder =>
      'O mapa de validação foi escolhido pela ordem do produto, não pela data';

  @override
  String warnValidationProductOrder(String hours) {
    return 'O mapa de validação EMS foi escolhido pela ordem do produto, não pela data. A sua imagem foi obtida $hours horas depois da cena NISAR, pelo que a água pode ter mudado.';
  }

  @override
  String get warnShortClassifierCalibrated =>
      'O modo Comparar não é uma verificação independente';

  @override
  String warnClassifierCalibrated(String classifierIou, String thresholdIou) {
    return 'O mapa de cheia é um classificador calibrado no mapa EMSR857 (IoU de validação cruzada espacial $classifierIou, contra $thresholdIou do mapa de limiar). A concordância com o EMS no modo Comparar não é uma verificação independente.';
  }

  @override
  String get warningExpandHint => 'Mostrar ou ocultar detalhes';

  @override
  String get appDisclaimer =>
      'Esta aplicação apoia decisões e não é um serviço de emergência.';

  @override
  String get populationIsModelled =>
      'A população é uma estimativa modelada, não um censo.';

  @override
  String get accessNormalVehicle => 'VEÍCULO';

  @override
  String get accessHighClearanceTruck => 'CAMIÃO ALTO';

  @override
  String get accessOnFoot => 'A PÉ';

  @override
  String get accessBoat => 'BARCO';

  @override
  String get statusCutOff => 'ISOLADO';

  @override
  String get statusDifficult => 'ACESSO DIFÍCIL';

  @override
  String get serviceClinic => 'Clínica';

  @override
  String get serviceMarket => 'Mercado';

  @override
  String get serviceShelter => 'Abrigo';

  @override
  String get serviceAidDepotLink => 'Ligação ao depósito de ajuda';

  @override
  String lostServices(String services) {
    return 'Perdidos: $services';
  }

  @override
  String limitedServices(String services) {
    return 'Difícil: $services';
  }

  @override
  String populationEstimate(String count) {
    return '$count pessoas (estimativa)';
  }

  @override
  String pocketTitle(String direction, String place) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'north': 'A norte de $place',
      'northeast': 'A nordeste de $place',
      'east': 'A leste de $place',
      'southeast': 'A sudeste de $place',
      'south': 'A sul de $place',
      'southwest': 'A sudoeste de $place',
      'west': 'A oeste de $place',
      'northwest': 'A noroeste de $place',
      'other': 'Perto de $place',
    });
    return '$_temp0';
  }

  @override
  String get whyFlagged => 'Motivo da sinalização';

  @override
  String whyCutOff(String services, String mode, String depth) {
    return 'A cheia isola esta zona de: $services. Para lá chegar é preciso: $mode. Água mais profunda na rota mais segura: $depth (estimativa).';
  }

  @override
  String whyDifficult(String services, String mode, String depth) {
    return 'A partir desta zona é difícil chegar a: $services. O acesso exige: $mode. Água mais profunda na rota mais segura: $depth (estimativa).';
  }

  @override
  String get estimatedMaxDepth => 'Água mais profunda na rota mais segura';

  @override
  String boatLegKm(String km) {
    return 'Trecho de barco: $km km';
  }

  @override
  String get routeComparison => 'Comparação de rotas';

  @override
  String get metric => 'Métrica';

  @override
  String get shortest => 'Mais curta';

  @override
  String get safestStar => 'Mais segura ★';

  @override
  String get distance => 'Distância';

  @override
  String get eta => 'Tempo';

  @override
  String get depthLevel => 'Prof. máxima';

  @override
  String get accessRisk => 'Risco';

  @override
  String get uncertainBridges => 'Pontes incertas';

  @override
  String get routesSame =>
      'Nesta área a rota mais segura é igual à mais curta.';

  @override
  String get routesDiffer =>
      'Nesta área a rota mais segura é diferente da mais curta.';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String durationMin(String min) {
    return '$min min';
  }

  @override
  String get levelHigh => 'ALTO';

  @override
  String get levelMedium => 'MÉDIO';

  @override
  String get levelLow => 'BAIXO';

  @override
  String stabilityLabel(String pct) {
    return 'Mantém-se em $pct% dos cenários de teste';
  }

  @override
  String worstCaseMode(String mode) {
    return 'No pior caso, prepare: $mode';
  }

  @override
  String get settingsTitle => 'Definições';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get presentationMode => 'Modo de apresentação';

  @override
  String get presentationModeSubtitle =>
      'Ocultar a navegação inferior para gravação de ecrã';

  @override
  String get dataDates => 'Datas dos dados';

  @override
  String dateNisarBefore(String date) {
    return 'NISAR antes da cheia: $date';
  }

  @override
  String dateNisarAfter(String date) {
    return 'NISAR depois da cheia: $date';
  }

  @override
  String dateEmsImage(String date) {
    return 'Imagem EMS: $date';
  }

  @override
  String get dataSources => 'Fontes de dados e atribuição';

  @override
  String get notAffiliated =>
      'Sem afiliação nem aprovação da NASA, do ISRO ou do Copernicus.';

  @override
  String depthBelow(String limit) {
    return '< $limit m';
  }

  @override
  String depthBetween(String low, String high) {
    return '$low–$high m';
  }

  @override
  String depthAbove(String limit) {
    return '> $limit m';
  }

  @override
  String get osmAttribution => '© contribuidores do OpenStreetMap';

  @override
  String get tooltipLocate => 'Mostrar a minha localização';

  @override
  String get tooltipZoomIn => 'Aproximar';

  @override
  String get tooltipZoomOut => 'Afastar';

  @override
  String get tooltipFit => 'Mostrar toda a área';

  @override
  String get layersControl => 'Camadas';

  @override
  String get layerDepth => 'Profundidade da água (estimativa)';

  @override
  String get layerFlood => 'Extensão da cheia';

  @override
  String get layerEms => 'Cheia oficial EMS';

  @override
  String get layerRoads => 'Estradas inundadas';

  @override
  String get layerPockets => 'Bolsões';

  @override
  String get layerRoutes => 'Rotas';

  @override
  String get layerServices => 'Serviços';

  @override
  String get layerCompare => 'Comparar com o EMS';

  @override
  String opacityLabel(String pct) {
    return 'Opacidade $pct%';
  }

  @override
  String get depthDetailNote =>
      'Com pouco zoom só se desenham as maiores manchas de profundidade, com contornos suavizados. Aproxime para as ver todas.';

  @override
  String get legendTitle => 'Legenda';

  @override
  String get legendSafest => 'Rota mais segura';

  @override
  String get legendShortest => 'Rota mais curta (tracejada)';

  @override
  String get legendRoad => 'Estrada inundada, por profundidade';

  @override
  String get legendEms => 'Contorno da cheia oficial EMS';

  @override
  String get legendClinic => 'Clínica';

  @override
  String get legendMarket => 'Mercado';

  @override
  String get legendShelter => 'Abrigo';

  @override
  String get legendDepot => 'Depósito de ajuda';

  @override
  String get legendMe => 'A minha localização';

  @override
  String get compareTitle => 'Comparar com o EMS';

  @override
  String compareBoth(String area) {
    return 'Ambos os mapas: $area km²';
  }

  @override
  String compareOnlyOurs(String area) {
    return 'Só o nosso mapa: $area km²';
  }

  @override
  String compareOnlyEms(String area) {
    return 'Só o EMS: $area km²';
  }

  @override
  String compareIou(String iou) {
    return 'Concordância (IoU): $iou';
  }

  @override
  String compareNotIndependent(
    String agreement,
    String crossValidation,
    String physicsOnly,
  ) {
    return 'Não é uma verificação independente: o nosso mapa de cheia foi calibrado neste mapa EMS, por isso a concordância com ele (IoU $agreement; $crossValidation na validação cruzada espacial) diz pouco sobre a exatidão noutros lugares. O mapa só com física, feito sem o EMS, concorda menos (IoU $physicsOnly) e é o mais conservador: marca menos cheia.';
  }

  @override
  String compareEmsDate(String date, String hours) {
    return 'Imagem EMS: $date, $hours horas depois da cena NISAR.';
  }

  @override
  String get compareTransparent =>
      'As áreas transparentes estão secas em ambos os mapas ou fora da área mapeada pelo EMS.';

  @override
  String routeSheetTitle(String pocket, String route) {
    return '$pocket: $route';
  }

  @override
  String get routeSafestLabel => 'Rota mais segura';

  @override
  String get routeShortestLabel => 'Rota mais curta';

  @override
  String get routeAccess => 'Acesso';

  @override
  String get routeWaterKm => 'Água na rota';

  @override
  String routeWaterValue(String shallow, String medium, String deep) {
    return '$shallow / $medium / $deep km (baixa / média / alta)';
  }

  @override
  String get routesIllustrative =>
      'As distâncias e os tempos são estimativas e a rota parte do depósito selecionado automaticamente.';

  @override
  String get sheetServiceType => 'Tipo';

  @override
  String get sheetStatus => 'Estado de acesso';

  @override
  String get clinicReachable => 'Acessível por estradas secas';

  @override
  String get clinicAccessFlooded => 'Estrada de acesso inundada';

  @override
  String clinicInsidePocket(String pocket) {
    return 'Dentro da área isolada $pocket';
  }

  @override
  String get clinicStatusNote =>
      'Indica se a clínica está ligada à principal rede de estradas secas. Não diz se um bolsão isolado consegue chegar até ela.';

  @override
  String get clinicDuplicateNote =>
      'Os registos do mapa podem repetir uma instalação, por isso clínicas próximas podem ser o mesmo local.';

  @override
  String get locationOff => 'A localização está desligada neste dispositivo.';

  @override
  String get locationDenied => 'A permissão de localização não foi dada.';

  @override
  String get locationOutside => 'Está fora da área mapeada.';

  @override
  String get viewOnMap => 'Mostrar no mapa';

  @override
  String get layerBaseline => 'Mapa de cheia só com física';

  @override
  String get layerBaselineNote =>
      'O mapa por limiar, de antes da calibração no EMS. É mais cauteloso: encontra menos cheia.';

  @override
  String get rankingTitle => 'Pesos da classificação';

  @override
  String get rankingShow => 'Mostrar os controlos';

  @override
  String get rankingHide => 'Ocultar os controlos';

  @override
  String get rankingReset => 'Repor';

  @override
  String get weightPeople => 'Pessoas';

  @override
  String get weightServiceLoss => 'Perda de serviços';

  @override
  String get weightDifficulty => 'Dificuldade';

  @override
  String get rankingChoiceNote =>
      'Os pesos são uma escolha, não ciência. Com 1,00 em todos, obtém-se a classificação publicada.';

  @override
  String rankingDominated(String pocket, String pct) {
    return '$pocket tem $pct% das pessoas estimadas, por isso domina esta lista e os pesos reordenam sobretudo os restantes.';
  }

  @override
  String get rankingTies =>
      'Bolsões com termos iguais empatam, sejam quais forem os pesos, e mantêm a ordem publicada.';

  @override
  String get rankingDepotNote =>
      'O depósito de ajuda foi selecionado automaticamente, por isso esta classificação é ilustrativa.';

  @override
  String missionNotFound(String id) {
    return 'Não existe a missão $id. Voltar à lista.';
  }

  @override
  String get serviceAccessTitle => 'Acesso a serviços';

  @override
  String get accessYes => 'acessível';

  @override
  String get accessDifficult => 'difícil';

  @override
  String get accessNo => 'cortado';

  @override
  String get accessNotApplicable => 'não aplicável';

  @override
  String accessWasMinutes(String minutes) {
    return '(cerca de $minutes min antes da cheia)';
  }

  @override
  String get priorityTermsTitle => 'Termos de prioridade (0 a 1)';

  @override
  String get verifyTitle => 'Verificar no terreno';

  @override
  String get verifyLowConfidence =>
      'Confiança baixa: pelo menos uma estrada de saída pode não estar realmente bloqueada (profundidade ou ponte incerta).';

  @override
  String get verifyBoatRoute =>
      'A rota de barco segue as estradas inundadas, o que é uma aproximação: verifique correntes, destroços e o local real de desembarque.';

  @override
  String get verifyUnstable =>
      'Esta área desaparece ou muda quando a extensão ou a profundidade da cheia variam ligeiramente: verifique-a primeiro.';

  @override
  String verifyShortestDeep(String km) {
    return 'A rota mais curta ($km km) atravessa água profunda: evite-a.';
  }

  @override
  String get verifyEstimates =>
      'As classes de profundidade vêm de um modelo de superfície e a população é modelada: confirme ambas com os responsáveis locais.';

  @override
  String get shareAlert => 'Partilhar alerta';

  @override
  String get alertTitle => 'Alerta para equipas no terreno';

  @override
  String get alertCopy => 'Copiar';

  @override
  String get close => 'Fechar';

  @override
  String alertHeadline(
    String rank,
    String pocket,
    String place,
    String people,
  ) {
    return 'ACCESSWATCH #$rank $pocket, $place: cerca de $people pessoas (estimativa).';
  }

  @override
  String alertNeeds(String mode) {
    return 'Precisa de: $mode.';
  }

  @override
  String alertBoatLeg(String mode, String km) {
    return '$mode ($km km por água)';
  }

  @override
  String alertRoute(String km, String risk, String confidence) {
    return 'Rota de $km km, risco $risk, confiança $confidence.';
  }

  @override
  String alertDataDate(String date) {
    return 'Dados de $date.';
  }

  @override
  String get alertCustomWeights => 'A classificação usa pesos personalizados.';

  @override
  String get alertDepot =>
      'A rota parte de um depósito selecionado automaticamente, por isso é ilustrativa.';

  @override
  String get alertVerify => 'VERIFIQUE NO TERRENO.';

  @override
  String verifyBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Verifique primeiro no terreno $count pontes na rota: o radar não consegue ver o seu estado.',
      one:
          'Verifique primeiro no terreno 1 ponte na rota: o radar não consegue ver o seu estado.',
    );
    return '$_temp0';
  }

  @override
  String get mySpotIntro =>
      'Compare a sua posição com o mapa da cheia: dentro da cheia ou não, a profundidade estimada e a clínica mais próxima a que pode chegar por estrada.';

  @override
  String get useMyLocation => 'Usar a minha localização';

  @override
  String get mySpotWaiting => 'A aguardar a localização…';

  @override
  String get testPositionBadge => 'Posição de teste (versão de depuração)';

  @override
  String get testPositionHint =>
      'Versão de depuração: prima longamente o mapa para definir uma posição de teste.';

  @override
  String get spotOutside =>
      'Está fora da área mapeada. O AccessWatch não pode verificar este local nem calcular rotas a partir dele.';

  @override
  String get spotInFlood => 'Dentro da cheia mapeada';

  @override
  String get spotNotInFlood => 'Fora da cheia mapeada';

  @override
  String spotDepth(String depth, String range) {
    return 'Profundidade estimada aqui: $depth $range';
  }

  @override
  String spotFloodedRoad(String metres) {
    return 'Estrada inundada mais próxima: a $metres m';
  }

  @override
  String spotSnapped(String metres) {
    return 'As rotas partem do ponto de estrada mais próximo, a $metres m';
  }

  @override
  String get routingFailed => 'Não foi possível calcular as rotas.';

  @override
  String get needsBoatAny =>
      'Precisa de barco: nenhuma rota por estrada chega a uma clínica a partir daqui.';

  @override
  String needsBoatClinic(String clinic) {
    return 'Precisa de barco: nenhuma rota por estrada chega a $clinic a partir daqui.';
  }

  @override
  String get needsBoatShort => 'Precisa de barco a partir do seu local';

  @override
  String get criterionFastest => 'Mais rápida';

  @override
  String get criterionSafest => 'Mais segura';

  @override
  String get targetUseNearest => 'Usar a mais próxima';

  @override
  String get careModeCar => 'Carro';

  @override
  String get careModeTruck => 'Camião alto';

  @override
  String get careModeFoot => 'A pé';

  @override
  String routeDistanceTime(String km, String minutes) {
    return '$km km, cerca de $minutes min';
  }

  @override
  String routeWater(String shallow, String medium) {
    return 'Água no caminho: $shallow m baixa, $medium m média (estimativa)';
  }

  @override
  String routeBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count pontes a verificar no terreno: o radar não consegue ver o seu estado',
      one:
          '1 ponte a verificar no terreno: o radar não consegue ver o seu estado',
    );
    return '$_temp0';
  }

  @override
  String get routeNoWalkingTime =>
      'O tempo a pé não está nos dados, por isso só se mostra a distância.';

  @override
  String get routeTimeRounded =>
      'O tempo é uma estimativa para veículo com dados arredondados: conte com alguns minutos a mais ou a menos.';

  @override
  String careRouteTo(String clinic, String mode) {
    return 'Para $clinic de $mode';
  }

  @override
  String get clearRoute => 'Limpar a rota';

  @override
  String get locationWhyTitle => 'Porquê a sua localização?';

  @override
  String get locationWhyBody =>
      'O AccessWatch usa a sua posição só enquanto o Mapa ou os Cuidados estão abertos, para a comparar com o mapa da cheia e calcular a rota para uma clínica. A aplicação não envia a sua posição para lado nenhum, mas os mosaicos do mapa da área que vê vêm do OpenStreetMap.';

  @override
  String get locationContinue => 'Continuar';

  @override
  String get locationNotNow => 'Agora não';

  @override
  String get warnShortDepotAssumed =>
      'A localização do depósito de ajuda é presumida';

  @override
  String get warnDepotAssumed =>
      'A localização do depósito de ajuda é presumida, não confirmada. As rotas e as prioridades dependem dela: confirme o depósito real antes de agir.';

  @override
  String dateEmsGap(String hours) {
    return 'A imagem EMS foi obtida $hours horas depois da cena NISAR \"depois\", pelo que a água pode ter mudado entretanto.';
  }

  @override
  String get knownIssuesTitle => 'Problemas conhecidos nestes dados';

  @override
  String get knownIssuesNone => 'Os dados não registam problemas conhecidos.';

  @override
  String issueRankInversion(String higher, String lower) {
    return '$higher fica acima de $lower, embora $lower tenha mais pessoas: os seus termos de prioridade são iguais depois de arredondados.';
  }

  @override
  String issueSafestCount(String report, String routes) {
    return 'O relatório de validação diz que a rota mais segura difere da mais curta em $report bolsão(ões), mas os dados das rotas mostram $routes.';
  }

  @override
  String issueRoadsOutsideCoverage(String count, String dry) {
    return '$count troços de estrada saem da cobertura do radar; $dry deles estão marcados como secos, o que pode só significar que o radar não os viu.';
  }

  @override
  String issuePocketOutsideCoverage(String pct, String pocket) {
    return '$pct% do bolsão $pocket fica fora da cobertura do radar.';
  }

  @override
  String issueClinicDuplicates(String records, String pairs) {
    return 'Os $records registos de clínicas incluem $pairs pares a menos de 100 m, por isso algumas podem ser a mesma clínica contada duas vezes.';
  }

  @override
  String get validationTitle => 'Concordância do mapa de cheia';

  @override
  String get scoreIou => 'Concordância com o EMS (IoU)';

  @override
  String get scoreF1 => 'Pontuação F1';

  @override
  String get scorePrecision => 'Precisão (cheia que marcamos e o EMS também)';

  @override
  String get scoreRecall => 'Sensibilidade (cheia do EMS que também marcamos)';

  @override
  String get scoreCrossValidation => 'Validação cruzada espacial (IoU)';

  @override
  String get scorePhysicsOnly => 'Mapa só com física vs EMS (IoU)';

  @override
  String get scoreStablePockets =>
      'Bolsões que se mantêm em todos os cenários de teste';

  @override
  String validationReference(String layer) {
    return 'Mapa de referência: $layer';
  }

  @override
  String get limitsTitle => 'Limitações, em palavras simples';

  @override
  String get limitDepth =>
      'O radar mostra onde está a água, não a sua profundidade. A profundidade é estimada a partir de um modelo de superfície, pelo que as classes são uma orientação, não medições.';

  @override
  String get limitRadar =>
      'O radar encontra bem a água aberta, mas pode não ver água debaixo de árvores ou entre edifícios.';

  @override
  String limitRoads(String pct, String fragments) {
    return 'As estradas vêm do OpenStreetMap: $pct% dos edifícios estão a menos de 150 m de uma estrada mapeada, e $fragments pequenos troços desligados foram deixados de fora.';
  }

  @override
  String get limitPopulation =>
      'O número de pessoas vem de um modelo de população, não de um censo.';

  @override
  String get limitBoat =>
      'As rotas de barco seguem as estradas inundadas, por isso as rotas reais pela água podem ser diferentes. As pontes não podem ser verificadas a partir do espaço.';

  @override
  String get limitThresholds =>
      'Os limites de profundidade e de veículos são valores ajustáveis: confirme-os com os responsáveis locais e verifique sempre no terreno.';

  @override
  String limitUntranslated(String text) {
    return '(Por agora só em inglês) $text';
  }

  @override
  String get colorsTitle => 'Como ler as cores';

  @override
  String get sourceWebsite => 'Site';

  @override
  String get sourceDocs => 'Documentação';

  @override
  String sourceDoi(String doi) {
    return 'DOI: $doi';
  }

  @override
  String sourceLicence(String licence) {
    return 'Licença: $licence';
  }

  @override
  String get readIntroAgain => 'Ler de novo a mensagem de segurança';

  @override
  String get introTitle1 => 'Veja quem a cheia isola';

  @override
  String get introBody1 =>
      'O AccessWatch mostra onde a água isola pessoas de clínicas, mercados e abrigos, e como chegar até elas. É feito a partir de radar de satélite: a profundidade e a população são estimativas.';

  @override
  String get introBody2 =>
      'O mapa da cheia vem do radar NISAR, comparado com o mapa Copernicus EMS. A profundidade e a população são estimativas, e os dados do radar ainda estão em fase beta.';

  @override
  String get safetyTitle => 'Antes de começar';

  @override
  String get safetyBody =>
      'O AccessWatch apoia decisões e não é um serviço de emergência. Os dados podem estar errados ou desatualizados: verifique sempre no terreno antes de agir.';

  @override
  String get safetyEmergency =>
      'Se estiver em perigo, ligue para o número de emergência local.';

  @override
  String get safetyAccept => 'Compreendo';

  @override
  String get rankingDepotAssumedNote =>
      'A localização do depósito de ajuda é presumida, não confirmada, por isso esta classificação é ilustrativa.';

  @override
  String get alertDepotAssumed =>
      'A rota parte de uma localização de depósito presumida e não confirmada, por isso é ilustrativa.';

  @override
  String dataAge(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'há $days dias',
      one: 'há 1 dia',
      zero: 'hoje',
    );
    return 'Dados obtidos a $date (radar NISAR). É um retrato de $_temp0: a água mudou desde então.';
  }

  @override
  String get offlineBanner =>
      'Sem ligação à rede. Tudo funciona com os dados dentro da aplicação, exceto o fundo do mapa e as ligações web.';

  @override
  String get offlineWorks =>
      'Todos os dados da análise estão dentro da aplicação, por isso funciona sem rede. Só o fundo do mapa e as ligações web precisam de rede.';

  @override
  String get mapSemanticsLabel =>
      'Mapa da inundação. As mesmas áreas estão listadas no separador Ajudar primeiro.';

  @override
  String alreadyAtClinic(String clinic) {
    return 'Já está em $clinic: não precisa de rota.';
  }

  @override
  String get alreadyHereShort => 'Está aqui';

  @override
  String get tabHelpFirst => 'Ajudar primeiro';

  @override
  String get tabFindCare => 'Encontrar cuidados';

  @override
  String get aboutThisData => 'Sobre estes dados';

  @override
  String mapAreasCutOff(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString áreas isoladas',
      one: '1 área isolada',
    );
    return '$_temp0';
  }

  @override
  String mapPeopleNear(String people, String places) {
    return 'Cerca de $people pessoas perto de $places';
  }

  @override
  String placesAnd(String first, String last) {
    return '$first e $last';
  }

  @override
  String get seeWhoNeedsHelp => 'Ver quem precisa de ajuda primeiro';

  @override
  String mapPreliminary(String date) {
    return 'Dados preliminares · imagem de $date · toque para detalhes';
  }

  @override
  String mapSnapshot(String date) {
    return 'Imagem de $date · toque para detalhes';
  }

  @override
  String get legendFlooded => 'Inundado';

  @override
  String get modeNeedsBoat => 'Precisa de barco';

  @override
  String get modeTruckCanReach => 'Camião consegue chegar';

  @override
  String get modeCarCanReach => 'Um carro consegue chegar';

  @override
  String get modeFootCanReach => 'Acessível a pé';

  @override
  String get openArea => 'Abrir';

  @override
  String areaMarkerLabel(String rank, String name, String mode) {
    return 'Área $rank: $name, $mode';
  }

  @override
  String get helpTitle => 'Quem precisa de ajuda primeiro';

  @override
  String helpSubtitle(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString áreas, as mais urgentes no topo',
      one: '1 área, a mais urgente no topo',
    );
    return '$_temp0';
  }

  @override
  String filterAllCount(String count) {
    return 'Todas $count';
  }

  @override
  String filterBoatCount(String count) {
    return 'Barco $count';
  }

  @override
  String filterTruckCount(String count) {
    return 'Camião $count';
  }

  @override
  String filterCarCount(String count) {
    return 'Carro $count';
  }

  @override
  String filterFootCount(String count) {
    return 'A pé $count';
  }

  @override
  String get customWeightsNote =>
      'Ordenado com os seus próprios pesos de prioridade. Reponha-os em Sobre estes dados › Avançado.';

  @override
  String areaCardLabel(String rank, String name, String people, String mode) {
    return 'Área $rank: $name. $people. $mode';
  }

  @override
  String get noAreasForFilter => 'Nenhuma área corresponde a este filtro.';

  @override
  String areaXofN(String rank, String count) {
    return 'Área $rank de $count';
  }

  @override
  String modeBoatDetail(String water, String road) {
    return 'Cerca de $water km por água, depois de $road km por estrada';
  }

  @override
  String get modeTruckTitle => 'Um camião de chassis alto consegue chegar';

  @override
  String get modeCarTitle => 'Um carro normal consegue chegar';

  @override
  String get modeFootTitle => 'Só se chega a pé';

  @override
  String get modeTruckDetail => 'Não precisa de barco, mas a estrada tem água.';

  @override
  String get lostTitle => 'O que deixaram de conseguir alcançar';

  @override
  String get harderTitle => 'O que ficou mais difícil de alcançar';

  @override
  String lostWasMinutes(String minutes) {
    return 'eram cerca de $minutes min';
  }

  @override
  String get serviceDepotLinkPlain => 'Ligação ao depósito de ajuda';

  @override
  String get safestRouteTitle => 'Rota por estrada mais segura';

  @override
  String routeCheckBridges(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Verifique $count pontes primeiro',
      one: 'Verifique 1 ponte primeiro',
    );
    return '$_temp0';
  }

  @override
  String get riskChipHigh => 'Risco alto';

  @override
  String get riskChipMedium => 'Risco médio';

  @override
  String get riskChipLow => 'Risco baixo';

  @override
  String get sureHigh => 'Alta';

  @override
  String get sureMedium => 'Média';

  @override
  String get sureLow => 'Baixa';

  @override
  String checkOnGround(String count) {
    return 'Verificar primeiro no terreno ($count)';
  }

  @override
  String get checkOnGroundTitle => 'Verificar primeiro no terreno';

  @override
  String get checkOnGroundIntro =>
      'Marque cada ponto quando uma equipa o tiver verificado. As marcas ficam neste telemóvel.';

  @override
  String howSure(String level) {
    return 'Qual a nossa certeza? $level';
  }

  @override
  String get howSureTitle => 'Qual a nossa certeza?';

  @override
  String howSureConfidence(String level) {
    return 'Confiança: $level';
  }

  @override
  String get routesIllustrativeShort =>
      'As rotas começam no depósito de ajuda, que é presumido. Use-as como guia.';

  @override
  String get findCareTitle => 'Encontrar cuidados';

  @override
  String get findCareSubtitle =>
      'A clínica mais próxima a que consegue chegar, e como';

  @override
  String get trySampleSpot => 'Experimentar um local de exemplo em Chókwè';

  @override
  String get sampleNotice => 'Local de exemplo, não a sua posição';

  @override
  String get nearestClinicLabel => 'Clínica mais próxima';

  @override
  String get chosenClinicLabel => 'A clínica que escolheu';

  @override
  String get byCar => 'De carro';

  @override
  String get byTruck => 'Camião de chassis alto';

  @override
  String get byFoot => 'A pé';

  @override
  String get canReach => 'Consegue chegar';

  @override
  String get noRoadRoute => 'Sem rota por estrada';

  @override
  String toClinic(String clinic) {
    return 'para $clinic';
  }

  @override
  String get showRouteOnMapLong => 'Mostrar a rota no mapa';

  @override
  String get routeBy => 'Rota por';

  @override
  String get aboutThisSpot => 'Sobre este local';

  @override
  String allClinicsTitle(String count) {
    return 'Todas as clínicas ($count)';
  }

  @override
  String get aboutPreliminary =>
      'Dados preliminares. Use-os como guia e verifique no terreno.';

  @override
  String get aboutGuideOnly => 'Use-os como guia e verifique no terreno.';

  @override
  String get plainNisarBeta =>
      'As imagens de radar NISAR são produtos beta, ainda não totalmente calibrados.';

  @override
  String get plainDepotAutoSelected =>
      'O depósito de ajuda foi escolhido automaticamente pela análise, por isso as rotas e prioridades são apenas ilustrativas.';

  @override
  String get plainDepotAssumed =>
      'O depósito de ajuda é presumido, não confirmado, por isso as rotas e prioridades são um guia.';

  @override
  String get plainValidationProductOrder =>
      'O mapa oficial usado para verificar o nosso foi escolhido pela ordem dos produtos, não pela imagem mais próxima no tempo.';

  @override
  String get plainClassifierCalibrated =>
      'O mapa de inundação foi calibrado com o mapa oficial deste evento, por isso concorda com esse mapa em parte por construção.';

  @override
  String get aboutFloodMapRow => 'Como foi feito o mapa de inundação';

  @override
  String get aboutMatchRow => 'Quanto coincide com o mapa oficial';

  @override
  String get aboutLimitsRow => 'Limites e problemas conhecidos';

  @override
  String get aboutSourcesRow => 'Fontes';

  @override
  String get aboutAgeRow => 'Idade dos dados e atualizações';

  @override
  String get aboutAdvancedRow => 'Avançado';

  @override
  String get aboutAdvancedSubtitle =>
      'Pesos de prioridade, Comparar, camadas só física e de profundidade';

  @override
  String get aboutLanguage => 'Idioma';

  @override
  String get aboutTextSize => 'Tamanho do texto';

  @override
  String textSizeOption(String pct) {
    return '$pct%';
  }

  @override
  String get aboutSafetyLine =>
      'Esta aplicação apoia decisões. Não é um serviço de emergência. Se estiver em perigo, ligue para o número de emergência local.';

  @override
  String get floodMapIntro =>
      'O mapa de inundação compara imagens de radar NISAR de antes e depois da cheia. A água aberta reflete o radar de forma diferente da terra, por isso uma mudança entre as duas imagens marca água nova.';

  @override
  String dataGenerated(String date) {
    return 'Análise executada: $date';
  }

  @override
  String get updateInfo =>
      'Os dados vêm de uma execução da análise. Quando a análise for executada de novo com imagens mais recentes, uma nova versão da aplicação traz os novos dados.';

  @override
  String get advancedMapNote =>
      'As alterações de camadas aparecem no separador Mapa.';
}
