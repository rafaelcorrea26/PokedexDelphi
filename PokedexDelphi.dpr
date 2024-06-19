program PokedexDelphi;

uses
  Vcl.Forms,
  fPrincipal in 'View\fPrincipal.pas' {frmPrincipal},
  fAvisos in 'View\fAvisos.pas' {frmAvisos},
  fModoADM in 'View\fModoADM.pas' {frmModoADM},
  uConnectionRest in 'httpClient\uConnectionRest.pas',
  dPrincipal in 'Model\dPrincipal.pas' {dtmPrincipal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmAvisos, frmAvisos);
  Application.CreateForm(TfrmModoADM, frmModoADM);
  Application.CreateForm(TdtmPrincipal, dtmPrincipal);
  Application.Run;
end.
