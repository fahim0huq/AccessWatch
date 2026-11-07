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
  String get accesswatchTitle => 'ACCESSWATCH';

  @override
  String get tabHome => 'Início';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabMissions => 'Missões';

  @override
  String get tabInfo => 'Info';

  @override
  String get loadingData => 'A carregar os dados da cheia…';

  @override
  String get loadError => 'Não foi possível carregar os dados da cheia.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get betaBadge => 'DADOS BETA';

  @override
  String get heroTitle =>
      'Identifique quem está isolado.\nChegue até eles com segurança.';

  @override
  String get heroSubtitle =>
      'Transforme observações de cheias em decisões claras de acesso humanitário.';

  @override
  String get missionControl => 'CONTROLO DE MISSÃO';

  @override
  String get missionControlSubtitle =>
      'Explorar a situação da cheia e do acesso';

  @override
  String get missionCards => 'FICHAS DE MISSÃO';

  @override
  String missionCardsSubtitle(String count) {
    return 'Fichas de resposta para $count bolsões classificados';
  }

  @override
  String get tapToOpenMap => 'Toque para abrir o mapa';

  @override
  String get floodPreviewLabel =>
      'Contorno da cheia mapeada e dos bolsões isolados. Toque para abrir o mapa.';

  @override
  String get eventMozambique2026 => 'Cheia em Moçambique, janeiro de 2026';

  @override
  String kpiPockets(String count) {
    return '$count bolsões';
  }

  @override
  String get kpiPocketsSub => 'Isolados ou de acesso difícil';

  @override
  String get kpiPeopleSub => 'Pessoas nos bolsões (estimativa modelada)';

  @override
  String floodAreaKm2(String area) {
    return '$area km²';
  }

  @override
  String get kpiFloodSub => 'Nova cheia mapeada';

  @override
  String get waterDepth => 'PROFUNDIDADE DA ÁGUA';

  @override
  String get kpiDepthSub =>
      'Troços de estrada inundados, por profundidade estimada';

  @override
  String depthCount(String count, String label) {
    return '$count $label';
  }

  @override
  String get depthDry => 'SECO';

  @override
  String get depthShallow => 'BAIXA';

  @override
  String get depthMedium => 'MÉDIA';

  @override
  String get depthDeep => 'ALTA';

  @override
  String get depthUnknown => 'DESCONHECIDA';

  @override
  String get depthEstimateWarning =>
      'A profundidade é uma estimativa, em classes e não em metros exatos. Verifique no terreno.';

  @override
  String get warningsTitle => 'AVISOS SOBRE OS DADOS';

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
  String get responseMissions => 'MISSÕES DE RESPOSTA';

  @override
  String rankedPockets(String count) {
    return '$count bolsões classificados';
  }

  @override
  String get filterAll => 'TODOS';

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
  String get estimatedPopulation => 'POPULAÇÃO ESTIMADA';

  @override
  String get whyFlagged => 'MOTIVO DA SINALIZAÇÃO';

  @override
  String whyCutOff(String services, String mode, String depth) {
    return 'A cheia isola esta zona de: $services. Para lá chegar é preciso: $mode. Água mais profunda na rota mais segura: $depth (estimativa).';
  }

  @override
  String whyDifficult(String services, String mode, String depth) {
    return 'A partir desta zona é difícil chegar a: $services. O acesso exige: $mode. Água mais profunda na rota mais segura: $depth (estimativa).';
  }

  @override
  String get estimatedMaxDepth => 'ÁGUA MAIS PROFUNDA NA ROTA MAIS SEGURA';

  @override
  String boatLegKm(String km) {
    return 'Trecho de barco: $km km';
  }

  @override
  String get routeComparison => 'COMPARAÇÃO DE ROTAS';

  @override
  String get metric => 'MÉTRICA';

  @override
  String get shortest => 'MAIS CURTA';

  @override
  String get safestStar => 'MAIS SEGURA ★';

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
      'Neste bolsão a rota mais segura é igual à mais curta.';

  @override
  String get routesDiffer =>
      'Neste bolsão a rota mais segura é diferente da mais curta.';

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
  String get analysisConfidence => 'CONFIANÇA DA ANÁLISE';

  @override
  String stabilityLabel(String pct) {
    return 'Mantém-se em $pct% dos cenários de teste';
  }

  @override
  String worstCaseMode(String mode) {
    return 'No pior caso, prepare: $mode';
  }

  @override
  String get back => 'Voltar';

  @override
  String get systemHonestyBrief => 'SISTEMA E TRANSPARÊNCIA';

  @override
  String get appTitle => 'AccessWatch Mobile';

  @override
  String get appSubtitle => 'Análise de acesso em cheias por radar de satélite';

  @override
  String get settingsTitle => 'DEFINIÇÕES';

  @override
  String get language => 'Idioma';

  @override
  String get languageDevice => 'Dispositivo';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String textSize(String pct) {
    return 'Tamanho do texto: $pct%';
  }

  @override
  String get presentationMode => 'Modo de apresentação';

  @override
  String get presentationModeSubtitle =>
      'Ocultar a navegação inferior para gravação de ecrã';

  @override
  String get dataDates => 'DATAS DOS DADOS';

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
  String get howDepthEstimated => 'COMO A PROFUNDIDADE É ESTIMADA';

  @override
  String get depthDescription =>
      'O radar mostra onde está a água, não a sua profundidade. As classes de profundidade são estimadas a partir do limite da cheia e de um modelo de elevação da superfície, pelo que são apenas indicativas.';

  @override
  String get waterDepthSummary => 'RESUMO DA PROFUNDIDADE DA ÁGUA';

  @override
  String get dataSources => 'FONTES DE DADOS E ATRIBUIÇÃO';

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
  String mapDates(String before, String after, String ems) {
    return 'NISAR $before – $after · EMS $ems';
  }

  @override
  String warningsToggle(String count) {
    return '$count avisos';
  }

  @override
  String get tooltipLayers => 'Camadas';

  @override
  String get tooltipLegend => 'Legenda';

  @override
  String get tooltipCompare => 'Comparar com o EMS';

  @override
  String get tooltipLocate => 'Mostrar a minha localização';

  @override
  String get tooltipZoomIn => 'Aproximar';

  @override
  String get tooltipZoomOut => 'Afastar';

  @override
  String get tooltipFit => 'Mostrar toda a área';

  @override
  String get layersControl => 'CAMADAS';

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
  String get legendTitle => 'LEGENDA';

  @override
  String legendPocketRisk(String level) {
    return 'Bolsão, risco $level';
  }

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
  String get compareTitle => 'COMPARAR COM O EMS';

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
  String get compareNotIndependent =>
      'Não é uma verificação independente: o nosso mapa de cheia foi calibrado neste mapa EMS.';

  @override
  String compareEmsDate(String date, String hours) {
    return 'Imagem EMS: $date, $hours horas depois da cena NISAR.';
  }

  @override
  String get compareTransparent =>
      'As áreas transparentes estão secas em ambos os mapas ou fora da área mapeada pelo EMS.';

  @override
  String get rankedPocketsTitle => 'BOLSÕES CLASSIFICADOS';

  @override
  String get allPockets => 'TODOS';

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
    return 'Dentro do bolsão $pocket';
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
  String get viewOnMap => 'MOSTRAR NO MAPA';

  @override
  String get layerBaseline => 'Mapa de cheia só com física';

  @override
  String get layerBaselineNote =>
      'O mapa por limiar, de antes da calibração no EMS. É mais cauteloso: encontra menos cheia.';

  @override
  String get rankingTitle => 'PESOS DA CLASSIFICAÇÃO';

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
  String publishedRank(String rank) {
    return 'Classificação publicada: #$rank';
  }

  @override
  String missionNotFound(String id) {
    return 'Não existe a missão $id. Voltar à lista.';
  }

  @override
  String get serviceAccessTitle => 'ACESSO A SERVIÇOS';

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
  String get priorityTermsTitle => 'TERMOS DE PRIORIDADE (0 A 1)';

  @override
  String get verifyTitle => 'VERIFICAR NO TERRENO';

  @override
  String get verifyLowConfidence =>
      'Confiança baixa: pelo menos uma estrada de saída pode não estar realmente bloqueada (profundidade ou ponte incerta).';

  @override
  String get verifyBoatRoute =>
      'A rota de barco segue as estradas inundadas, o que é uma aproximação: verifique correntes, destroços e o local real de desembarque.';

  @override
  String get verifyUnstable =>
      'Este bolsão desaparece ou muda quando a extensão ou a profundidade da cheia variam ligeiramente: verifique-o primeiro.';

  @override
  String verifyShortestDeep(String km) {
    return 'A rota mais curta ($km km) atravessa água profunda: evite-a.';
  }

  @override
  String get verifyEstimates =>
      'As classes de profundidade vêm de um modelo de superfície e a população é modelada: confirme ambas com os responsáveis locais.';

  @override
  String get shareAlert => 'PARTILHAR ALERTA';

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
  String get tabCare => 'Cuidados';

  @override
  String get careTitle => 'CUIDADOS';

  @override
  String get careSubtitle => 'Clínicas e como chegar até elas';

  @override
  String get mySpotTitle => 'O MEU LOCAL';

  @override
  String get mySpotIntro =>
      'Compare a sua posição com o mapa da cheia: dentro da cheia ou não, a profundidade estimada e a clínica mais próxima a que pode chegar por estrada.';

  @override
  String get useMyLocation => 'Usar a minha localização';

  @override
  String get mySpotWaiting => 'A aguardar a localização…';

  @override
  String get testPositionBadge => 'POSIÇÃO DE TESTE (VERSÃO DE DEPURAÇÃO)';

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
  String spotNearestClinic(String clinic, String mode, String km) {
    return 'Clínica mais próxima por estrada: $clinic ($mode, $km km)';
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
  String get routesToClinic => 'ROTA PARA UMA CLÍNICA';

  @override
  String get criterionFastest => 'Mais rápida';

  @override
  String get criterionSafest => 'Mais segura';

  @override
  String get targetNearest =>
      'Para a clínica mais próxima que cada meio de transporte alcança.';

  @override
  String targetChosen(String clinic) {
    return 'Para $clinic';
  }

  @override
  String get targetUseNearest => 'Usar a mais próxima';

  @override
  String get careModeCar => 'Carro';

  @override
  String get careModeTruck => 'Camião alto';

  @override
  String get careModeFoot => 'A pé';

  @override
  String noRouteForMode(String mode) {
    return 'Sem rota de $mode: há água ou estradas bloqueadas no caminho.';
  }

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
  String get showRouteOnMap => 'Mostrar no mapa';

  @override
  String careRouteTo(String clinic, String mode) {
    return 'Para $clinic de $mode';
  }

  @override
  String get clearRoute => 'Limpar a rota';

  @override
  String clinicsTitle(String count) {
    return 'CLÍNICAS ($count)';
  }

  @override
  String get locationWhyTitle => 'Porquê a sua localização?';

  @override
  String get locationWhyBody =>
      'O AccessWatch usa a sua posição só enquanto o Mapa ou os Cuidados estão abertos, para a comparar com o mapa da cheia e calcular a rota para uma clínica. A aplicação não envia a sua posição para lado nenhum, mas os mosaicos do mapa da área que vê vêm do OpenStreetMap.';

  @override
  String get locationContinue => 'Continuar';

  @override
  String get locationNotNow => 'Agora não';
}
