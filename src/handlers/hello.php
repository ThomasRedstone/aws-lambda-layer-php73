<?php
function main($eventData) : array
{
    $event = json_decode($eventData, true);
    $response = [
        'isBase64Encoded' => false,
        'statusCode' => 200,
        'headers' => ['content-type' => 'text/html'],
        'body' => json_encode([
            'method' => $event['httpMethod'],
            'queryString' => empty($event['multiValueQueryStringParameters']) ? false : $event['multiValueQueryStringParameters'],
            'urlPath' => empty($event['requestContext']['path']) ? false : $event['requestContext']['path'],
            'postBody' => empty($event['body']) ? false : event['body']
        ])
    ];
    #$response['eventData'] = $eventData;
    #$data = json_decode($eventData);
    #$response['data'] = $data;
    return $response;
}
