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
  String get depthShallowRange => '< 0,3 m';

  @override
  String get depthMediumRange => '0,3–0,8 m';

  @override
  String get depthDeepRange => '> 0,8 m';

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
  String get servicesLost => 'SERVIÇOS PERDIDOS';

  @override
  String get servicesLimited => 'SERVIÇOS DE ACESSO DIFÍCIL';

  @override
  String serviceWasMinutes(String service, String minutes) {
    return '$service (cerca de $minutes min antes da cheia)';
  }

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
  String get verifyOnGround => 'Verifique no terreno antes de agir.';

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
}
