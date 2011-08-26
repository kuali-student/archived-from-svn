# Converts impex xml data files into liquibase changesets


require 'xmlsimple'

@indent = "\t"
@ksHomeDir = '/home/andy/src/kualiWorkspace/ks-1.3'
@impexDirName = @ksHomeDir + '/ks-cfg-dbs/ks-embedded-db/src/main/impex'
@dataHeader = '<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-2.0.xsd">'
@dataFooter = '</databaseChangeLog>'

def writeInsertTags(inFileName, outFile)

	table = XmlSimple.xml_in(inFileName)

	table.each_key do |tableName|
		table[tableName].each do |row|
			outFile.puts (@indent * 2) + '<insert tableName="' + tableName + '">'
			row.each_key do |colName|
				colValue = row[colName]
				colValue.gsub!('&', '&amp;')
				colValue.gsub!('<', '&lt;')
				colValue.gsub!('"', '&quot;')
				outFile.puts (@indent * 3) + '<column name="' + colName+ '" value="' + colValue + '"/>'
			end
			outFile.puts (@indent * 2) + '</insert>'
		end
		
	end

end

@tableModules = Hash.new
@fileNameSuffix = '-data-lb.xml';

def parseConfigFile(configFile, moduleName)
	configFile.each_line do |line|
		parts = line.split(':')
		
		tableName = parts[1].strip
		fileName = parts[0].strip
		
		dirName = moduleName + '/' + fileName.split('/')[0]
		
		# check for module dir
		if !Dir.exist? moduleName
			Dir.mkdir moduleName
		end
	
		# check for section dir
		if !Dir.exist? dirName
			Dir.mkdir dirName
		end
		
		# check for data dir
		dirName << "/data"
		
		if !Dir.exist? dirName
			Dir.mkdir dirName
		end
		
		@tableModules[tableName] = dirName
	end
end

#writeInsertTags('testData.xml', nil)

@configFiles = {'coreTables.txt' => 'ks-core-lb', 
			'lumTables.txt' => 'ks-lum-lb',
			'enrollTables.txt' => 'ks-enroll-lb', 
			'riceTables.txt' => 'ks-rice-lb', 
			'miscTables.txt' => 'ks-misc-lb'}
			
@configFiles.each do |moduleConfigFileName, moduleName|
	configFile = File.open(moduleConfigFileName, 'r')
	
	parseConfigFile(configFile, moduleName)
end

impexDir = Dir.open(@impexDirName)

impexDir.each do |dirEntry|
	if dirEntry.include? '.xml' and dirEntry != 'schema.xml'
		tableName = dirEntry.sub('.xml', '')
		absoluteFile = impexDir.path + '/' + dirEntry
		if @tableModules[tableName] == nil
			puts tableName
		end
		outputPath = @tableModules[tableName] + '/' + dirEntry
		
		outputFile = File.open(outputPath, 'w')
		outputFile.puts @dataHeader
		outputFile.puts @indent + '<changeSet id="' + tableName + '-initial-data" author="alubbers">'
		
		writeInsertTags(absoluteFile, outputFile)
		
		outputFile.puts @indent + '</changeSet>'
		outputFile.puts@dataFooter
		outputFile.close
	end
end



