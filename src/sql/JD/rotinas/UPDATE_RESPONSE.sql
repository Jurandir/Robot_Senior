UPDATE SIC..JOHNDEERE_INFO
SET RESPONSE= '${retorno}',
    FILEXML = '${filexml}'
WHERE CODEINSERT = ${codigo}
