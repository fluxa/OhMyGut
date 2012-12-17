// Imports
var http = require('http')
var express = require('express')
var app = express();
var GoogleSpreadsheets = require('google-spreadsheets');
var plist = require('plist');
var fs = require('fs');


// Express config
app.configure(function(){
	app.set('views', __dirname + '/views');
	app.set('view engine', 'jade');
	app.set('view options', { layout: false });
	app.use(express.cookieParser());
	app.use(express.bodyParser());
	app.use(express.static(__dirname + '/public'));
});


var server = http.createServer(app);


String.prototype.format = function() {
	var args = arguments;
	return this.replace(/{(\d+)}/g, function(match, number) { 
		return typeof args[number] != 'undefined' ? args[number] : match;
	});
};

// ENV
var port = process.env.PORT || process.env.VCAP_APP_PORT || 5008;
console.log('listening on port %d',port);
server.listen(port);


//WIRING
app.get('/', function(req,res){
	res.render('index',{
		title:'ohmygut-data',
		brand:'fluxa'
	});
});

app.get('/sxgroups',function(req,res) {
	loadFromSpreadsheet(
		0,
		'R2C1:R{0}C2',
		'SXGroups.plist', 
		function(row) {
			return {'gid':parseInt(row['1'].value),'name':row['2'].value};
		},
		function(data) {
			res.send(data);
		}
	);
});

app.get('/sxs',function(req,res) {
	loadFromSpreadsheet(
		1,
		'R2C1:R{0}C3',
		'SXs.plist', 
		function(row) {
			return {'gid':parseInt(row['1'].value),'sxid':parseInt(row['2'].value),'text':row['3'].value};
		},
		function(data) {
			res.send(data);
		}
	);
});

app.get('/foodgroups',function(req,res) {
	loadFromSpreadsheet(
		2,
		'R2C1:R{0}C3',
		'FoodGroups.plist', 
		function(row) {
			var obj = {'gid':parseInt(row['1'].value),'name':row['2'].value,'notes':''};
			if (row['3']) {
				obj.notes = row['3'].value;
			};
			return obj;
		},
		function(data) {
			res.send(data);
		}
	);
});

app.get('/foods',function(req,res) {
	loadFromSpreadsheet(
		3,
		'R2C1:R{0}C10',
		'Foods.plist', 
		function(row) {

			var obj = {
				'gid':parseInt(row['1'].value),
				'foodid':parseInt(row['2'].value),
				'name':row['3'].value,
				'scdlegal':parseInt(row['4'].value),
				'gapslegal':parseInt(row['5'].value),
				'histamine':parseInt(row['6'].value),
				'fodmaps':parseInt(row['7'].value),
				'fiber':parseInt(row['8'].value),
				'goitrogenic':parseInt(row['9'].value),
				'notes':''
			};

			if (row['10']) {
				obj.notes = row['10'].value;
			};
			return obj;
		},
		function(data) {
			res.send(data);
		}
	);
});

app.get('/diets',function(req,res) {
	loadFromSpreadsheet(
		4,
		'R2C1:R{0}C3',
		'Diets.plist', 
		function(row) {
			var obj = {'dietid':row['1'].value,'name':row['2'].value,'notes':''};
			if (row['3']) {
				obj.notes = row['3'].value;
			};
			return obj;
		},
		function(data) {
			res.send(data);
		}
	);
});


//Spreadsheet
var spreadsheetKey = '0AjHDCoSXO0VtdHhHZ2FYT1R3bGVsZ0Ewc0tQeDNFaGc';

function response(success,data,info) {
	return {
		'data' : success ? data : {},
		'success' : success,
		'error' : success ? data : '',
		'info' : info
	};
}

function loadFromSpreadsheet(sheetn, rangeFormat, filename, parser, loaded) {
	
	GoogleSpreadsheets({
		key: spreadsheetKey
	}, function(err, spreadsheet) {

		console.log(spreadsheet);

		var worksheet = spreadsheet.worksheets[sheetn];
		var count = worksheet.rowCount;
		var range = rangeFormat.format(count);
		
		var info = count + ' rows in range ' + range + ' from sheet ' + worksheet.title + ' was saved to ' + filename;
		console.log(info);

		worksheet.cells({
			range: range
		}, function(err, cells) {
			var data = [];
			if (!err) {
				for (var i = 2; i <= count; i++) {;
					var row = cells.cells['{0}'.format(i)];
					data.push(parser(row));
				};
				var plistData = plist.build(data);
				plistData = plistData.replace(/&/g,'&amp;');
				//console.log(plistData);
				fs.writeFile(__dirname+'/public/data/'+filename,plistData, function(err){
					if (!err) {
						loaded(response(true,data,info));
					} else {
						console.log(err);
						loaded(response(false,err,''));
					};
				});
			} else {
				console.log(err);
				loaded(response(false,err,''));
			}
		});
		
	});

}

