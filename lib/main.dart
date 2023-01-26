import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return ChangeNotifierProvider(
			create: (context) => MyAppState(),
			child: MaterialApp(
				title: 'Namer App',
				theme: ThemeData(
					useMaterial3: true,
					colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
				),
				home: MyHomePage(),
			),
		);
	}
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

	var favorites = <WordPair>[];

  /* 
    Todo: 
    Add a 'toggleFavorite' function which adds or removes the current word to or from the favorites array in the AppState
  */
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	var selectedIndex = 0;

	@override
	Widget build(BuildContext context) {
		Widget page;

		switch (selectedIndex) {
			case 0:
				page = GeneratorPage();
				break;
			case 1:
				page = FavoritesPage();
				break;
			default:
				throw UnimplementedError('no widget for $selectedIndex');
		}

		return LayoutBuilder(
		  builder: (context, constraints) {
		    return Scaffold(
		    	body: Row(
		    		children: [
		    			SafeArea(
		    				child: NavigationRail(
		    					extended: constraints.maxWidth >= 600,
		    					destinations: [
		    						NavigationRailDestination(
		    							icon: Icon(Icons.home),
		    							label: Text('Home'),
		    						),
		    						NavigationRailDestination(
		    							icon: Icon(Icons.favorite),
		    							label: Text('Favorites'),
		    						),
		    					],
		    					selectedIndex: selectedIndex,
		    					onDestinationSelected: (value) {
		    						setState(() {
		    							selectedIndex = value;
		    						});
		    					},
		    				),
		    			),
		    			Expanded(
		    				child: Container(
		    					color: Theme.of(context).colorScheme.primaryContainer,
		    					child: page,
		    				),
		    			),
		    		],
		    	),
		    );
		  }
		);
	}
}

class GeneratorPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();
		var pair = appState.current;

    /*
      Todo:
      Add a function which checks the AppState's 'favorites' array for the current WordPair.
        - If the current WordPair is present in the favorites array, show a filled heart icon.
        - If the current WordPair not present in the favorites array, show an outlined heart icon.
      
      Icons can be stored in a variable of the IconData datatype.
        - A favorited WordPair has to show the icon 'Icons.favorite'.
        - A non-favorited WordPair has to show the icon 'Icons.favorite_border'.
    */

		return Center(
			child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            /*
              Add an ElevatedButton, which supports the display of an icon --> ElevatedButton.icon
              The button's icon property should be dynamically filled with the IconData variable determined by the function above.
              The button's text should display 'Like'
            */
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
            ],
          ),
        ],
			),
		);
	}
}

class FavoritesPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		var appState = context.watch<MyAppState>();

		if (appState.favorites.isEmpty) {
			return Center(
				child: Text('No favorites yet.'),
			);
		}

		return ListView(
			children: [
				Padding(
					padding: const EdgeInsets.all(20),
					child: Text('You have ${appState.favorites.length} ${appState.favorites.length == 1 ? "favorite" : "favorites" }:'),
				),
				for (var pair in appState.favorites)
					ListTile(
						leading: Icon(Icons.favorite),
						title: Text(pair.asLowerCase),
					),
			],
		);
	}
}


class BigCard extends StatelessWidget {
	const BigCard({
		Key? key,
		required this.pair,
	}) : super(key: key);

	final WordPair pair;

	@override
	Widget build(BuildContext context) {
		var theme = Theme.of(context);
		var style = theme.textTheme.displayMedium!.copyWith(
			color: theme.colorScheme.onPrimary,
		);

		return Card(
			color: theme.colorScheme.primary,
			elevation: 10,
			child: Padding(
			  padding: const EdgeInsets.all(15),
			  child: Text(
			  		pair.asLowerCase,
			  		style: style,
			  		semanticsLabel: pair.asPascalCase,
			  ),
			),
		);
	}
}