CREATE OR REPLACE TRIGGER TRG_RESTRINGE_ALTERACAO_ALTA_MEDICA
/************************************************************************************
 *  OWNER: SYS                                                                   *
 ************************************************************************************
 *  OBJETO: SYS.TRG_RESTRINGE_ALTERACAO_ALTA_MEDICA                         *
 ************************************************************************************
 *  OBJETIVO DA TRIGGER:                                                            *
 *    - Este objeto tem por objetivo restringer a alteração na alta médica          *
 *      Permitindo apenas para os usuários DBA                                      *
 *|--------------------------------------------------------------------------------|*
 *| Data       | Proprietario            | Dev.              | Versao | Alteracao  |*
 *|------------+-------------------------+------------------+--------+-------------|*
 *| 20/06/2025 | SYS                     | Gabriel           | 1.0    | Criacao    |*
 *|--------------------------------------------------------------------------------|*
 ************************************************************************************/
BEFORE UPDATE OF DT_ALTA_MEDICA ON TABELAATENDIMENTO
FOR EACH ROW
DECLARE
    V_USERNAME       VARCHAR2(100);
    V_CD_PRESTADOR   PRESTADORES.CD_PRESTADOR%TYPE;
    V_COD_TIPO_PRESTADOR  PRESTADORES.CD_TIP_PRESTA%TYPE;
BEGIN
   IF :OLD.TIPO_ATENDIMENTO = 'I'
   THEN
        V_USERNAME := DBAMV.PKG_MV_VARIAVEIS.FNC_GET_USUARIO; -- Usuário logado no momento de executar a trigger.
        
        IF V_USERNAME NOT IN ('DBAMV')
        THEN    
            BEGIN     
                SELECT US.CD_PRESTADOR
                  INTO V_COD_PRESTADOR
                  FROM USUARIOS_SISTEMA US
                 WHERE US.CD_USUARIO = V_USERNAME;    
                     
                IF V_COD_PRESTADOR IS NULL
                THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Somente médicos podem alterar a alta médica.');
                END IF; 
                                        
                BEGIN 
                    SELECT PR.COD_TIPO_PRESTADOR
                      INTO V_COD_TIPO_PRESTADOR
                      FROM PRESTADORES_SISTEMA PR
                     WHERE PR.CD_PRESTADOR = V_CD_PRESTADOR;
                    
                    IF :OLD.DT_ALTA_MEDICA IS NOT NULL AND :NEW.DT_ALTA_MEDICA IS NULL AND V_COD_TIPO_PRESTADOR <> 8  
                    THEN 
                        RAISE_APPLICATION_ERROR(-20002, 'Somente médicos podem alterar a alta médica.');
                    END IF;
                    
                    EXCEPTION 
                        WHEN NO_DATA_FOUND THEN
                             RAISE_APPLICATION_ERROR(-20004, 'Prestador não encontrado.');              
                 END; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     RAISE_APPLICATION_ERROR(-20005, 'Usuario não encontrado.'); 
            END;
        END IF;        
    END IF;  
END;

