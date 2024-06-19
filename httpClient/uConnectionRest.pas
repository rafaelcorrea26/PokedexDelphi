unit uConnectionRest; // Classe que conecta na API

interface

uses
  REST.Types,
  REST.Client,
  System.SysUtils,
  Vcl.ExtCtrls,
  System.JSON,
  System.DateUtils,
  Vcl.Dialogs, Winapi.Windows, dPrincipal, System.Classes;

type

  TPokemonData = record
    Name: String;
    ImageUrl: String;
    Image: TBitmap;
  end;


  TConnectionRest = class(TObject)
  private
    FRestClient: TRESTClient;
    FRestRequest: TRESTRequest;
    FRestResponse: TRESTResponse;
  public
    destructor Destroy; override;
    constructor Create;

    // Componentes REST
    property RestClient: TRESTClient read FRestClient write FRestClient;
    property RestResponse: TRESTResponse read FRestResponse write FRestResponse;
    property RestRequest: TRESTRequest read FRestRequest write FRestRequest;

    // Fun��es Auxiliares
    procedure ResetAllConfigsRequest;

    // Fun��es GET
    procedure BuscaPokemons(pPokemons: String = '');
    function LoadImageFromURL(URL: String): TBitmap;

  end;

implementation

constructor TConnectionRest.Create;
begin
  FRestClient := TRESTClient.Create('');
  FRestRequest := TRESTRequest.Create(nil);
  FRestResponse := TRESTResponse.Create(nil);

end;

destructor TConnectionRest.Destroy;
begin
  FRestClient.Free;
  FRestRequest.Free;
  FRestResponse.Free;
end;

function TConnectionRest.LoadImageFromURL(URL: String): TBitmap;
var
  Stream: TMemoryStream;
  Bitmap: TBitmap;
begin
   ResetAllConfigsRequest;
    FRestRequest.Client.BaseURL := URL;

  FRestRequest.Method := rmGET;
  FRestRequest.Execute;

  if (FRestRequest.Response.StatusCode = 200) then
  begin
      Stream := TMemoryStream.Create;
      try
//        Stream.CopyFrom(FRestRequest.Response.BodyStream);
//        Stream.Position := 0;
//        Bitmap := TBitmap.Create;
//        try
//          Bitmap.LoadFromStream(Stream);
//        finally
//          FreeAndNil(Bitmap);
//        end;
      finally
        FreeAndNil(Stream);
      end;
    end;

end;

procedure TConnectionRest.BuscaPokemons(pPokemons: String);
var
  iTamanho, i: integer;
  fJson: TJSONObject;
  fArrayJson: TJSONArray;
  ImageURL: String;
  PokemonData : TPokemonData;
begin
  ResetAllConfigsRequest;
  if pPokemons = EmptyStr then
    FRestRequest.Client.BaseURL := 'https://pokeapi.co/api/v2/pokemon'
  else
    FRestRequest.Client.BaseURL := 'https://pokeapi.co/api/v2/pokemon/' + pPokemons;

  FRestRequest.Method := rmGET;
  FRestRequest.Execute;

  if (FRestRequest.Response.StatusCode = 200) then
  begin

    fJson := TJSONObject.ParseJSONValue(FRestRequest.Response.Content) as TJSONObject;
    fArrayJson := fJson.GetValue<TJSONArray>('results') as TJSONArray;       //images: sprites = jsonobject // nome: name = jsonobject
    iTamanho := fArrayJson.Count;

    for i := 0 to fArrayJson.Count - 1 do
    begin
      if (fArrayJson <> nil) then
      begin
        fJson := fArrayJson.Items[i] as TJSONObject;
        fJson := fJson.GetValue<TJSONObject> as TJSONObject;
        begin

//          PokemonData := TPokemonData.Create;
//          PokemonData.Name := PokemonList.Results[i].Name;
//          ImageURL := PokemonList.Results[i].Url;
//
//          // Load the image from the URL
//          PokemonData.Image := LoadImageFromURL(ImageURL);
//
//          // Add the data to the ClientDataSet
//          dtmprincipal.cdspokemon.AddRecord;
//          ClientDataSet.Fields['Name'].Value := PokemonData.Name;
//          ClientDataSet.Fields['ImageUrl'].Value := ImageURL;
//          ClientDataSet.Fields['Image'].Value := PokemonData.Image;
          ShowMessage(fJson.ToJSON);
        end;
      end;
    end;
  end
  else if (FRestRequest.Response.StatusCode = 400) then
  begin
    raise Exception.Create('Error Message');
  end;
end;

procedure TConnectionRest.ResetAllConfigsRequest; // Fun��o inicial
begin
  FRestClient.ResetToDefaults;
  FRestClient.BaseURL := EmptyStr;
  FRestResponse.ResetToDefaults;
  FRestResponse.ContentEncoding := 'utf8';
  FRestRequest.ResetToDefaults;
  FRestRequest.Client := FRestClient;
  FRestRequest.ClearBody;
  FRestRequest.Response := FRestResponse;
  FRestRequest.Params.Clear;
end;

end.
