import 'package:funcao/funcao.dart' as funcao;
import 'dart:async';

void main() {
  print('=== INÍCIO DO PROGRAMA ===');

  // Execução de funções assíncronas básicas
  runBasicAsyncFunctions();

  // Demonstração de concorrência com Futures
  runConcurrentFutures();

  // Demonstração de Streams
  runStreamExample();

  print('=== FIM DO PROGRAMA (mas as operações assíncronas continuam) ===');
}

// 1. Funções Assíncronas Básicas com async/await
void runBasicAsyncFunctions() async {
  print('\n--- Funções Assíncronas Básicas ---');
  
  // Chamada de função assíncrona com await - execução sequencial
  print('Iniciando operação sequencial...');
  String resultado1 = await fetchUserData();
  print('Resultado 1: $resultado1');
  
  String resultado2 = await fetchUserProfile(resultado1);
  print('Resultado 2: $resultado2');
  
  // Chamada sem await - execução concorrente
  print('Iniciando operações concorrentes...');
  Future<String> future1 = fetchUserData();
  Future<String> future2 = fetchUserProfile('ID-456');
  
  // Usando Future.wait para aguardar múltiplos Futures
  List<String> resultados = await Future.wait([future1, future2]);
  print('Resultados concorrentes: $resultados');
}

// Função assíncrona que simula busca de dados do usuário
Future<String> fetchUserData() async {
  print('fetchUserData iniciado...');
  await Future.delayed(Duration(seconds: 2)); // Simula operação demorada
  print('fetchUserData concluído!');
  return 'ID-123'; // Retorna um ID fictício
}

// Função assíncrona que simula busca de perfil do usuário
Future<String> fetchUserProfile(String userId) async {
  print('fetchUserProfile para $userId iniciado...');
  await Future.delayed(Duration(seconds: 3)); // Simula operação mais demorada
  print('fetchUserProfile para $userId concluído!');
  return 'Perfil de $userId'; // Retorna um perfil fictício
}

// 2. Concorrência com Futures
void runConcurrentFutures() {
  print('\n--- Concorrência com Futures ---');
  
  // Criando múltiplos Futures que executam concorrentemente
  Future<void> task1 = Future(() {
    print('Task 1 iniciada');
    // Simula trabalho pesado
    for (var i = 0; i < 5; i++) {
      print('Task 1 progresso: ${i + 1}/5');
      sleep(Duration(milliseconds: 500));
    }
    print('Task 1 concluída');
  });

  Future<void> task2 = Future(() {
    print('Task 2 iniciada');
    // Simula trabalho pesado
    for (var i = 0; i < 3; i++) {
      print('Task 2 progresso: ${i + 1}/3');
      sleep(Duration(milliseconds: 800));
    }
    print('Task 2 concluída');
  });

  // Usando then para encadear operações
  task1.then((_) {
    print('Task 1 terminou, iniciando ação subsequente');
    return Future.delayed(Duration(seconds: 1));
  }).then((_) {
    print('Ação subsequente concluída');
  });

  // Tratamento de erros em Futures
  Future.error('Erro simulado').catchError((error) {
    print('Erro capturado: $error');
  });

  // Executando Futures em paralelo
  Future.wait([task1, task2]).then((_) {
    print('Todas as tasks concorrentes foram concluídas');
  });
}

// 3. Trabalhando com Streams
void runStreamExample() {
  print('\n--- Trabalhando com Streams ---');
  
  // Criando um StreamController
  StreamController<int> controller = StreamController<int>();
  
  // Obtendo a stream do controller
  Stream<int> numberStream = controller.stream;
  
  // Ouvindo a stream (assinante 1)
  StreamSubscription<int> subscription1 = numberStream.listen(
    (number) {
      print('Assinante 1 recebeu: $number');
    },
    onError: (error) {
      print('Assinante 1 erro: $error');
    },
    onDone: () {
      print('Assinante 1: Stream fechada');
    },
  );
  
  // Adicionando outro ouvinte (assinante 2)
  StreamSubscription<int>? subscription2;
  subscription2 = numberStream.listen(
    (number) {
      print('Assinante 2 recebeu: $number');
      if (number == 3) {
        subscription2?.cancel(); // Cancelando a assinatura após receber 3
        print('Assinante 2 cancelado');
      }
    },
  );
  
  // Adicionando dados à stream
  for (int i = 1; i <= 5; i++) {
    controller.add(i); // Envia dados para os assinantes
    sleep(Duration(milliseconds: 300));
  }
  
  // Fechando a stream
  Future.delayed(Duration(seconds: 1), () {
    controller.close();
    print('StreamController fechado');
  });
  
  // Exemplo de Stream com período
  print('\nStream periódica:');
  Stream<int> periodicStream = Stream.periodic(
    Duration(milliseconds: 400),
    (count) => count,
  ).take(5); // Limita a 5 eventos
  
  periodicStream.listen(
    (count) => print('Evento periódico: $count'),
    onDone: () => print('Stream periódica concluída'),
  );
  
  // Transformando Streams
  print('\nStream transformada:');
  Stream<int> transformedStream = numberStream
      .where((number) => number % 2 == 0) // Filtra apenas pares
      .map((number) => number * 10); // Multiplica por 10
  
  transformedStream.listen(
    (number) => print('Número transformado: $number'),
  );
  
  // Adicionando mais dados após a transformação
  controller.add(2);
  controller.add(3);
  controller.add(4);
}

// Função auxiliar para simular delay síncrono
void sleep(Duration duration) {
  var end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
}
    // Espera ocupada - apenas para exemplo (não usar em produção)
  }