/*
--==============================================
-- Name    : D1_FN_CO_GetDictionaryTrans
-- Propose : Get the Text Translation
             DECLARE @iDictionaryCode NVARCHAR(100)  = 'D1_COL_DictionaryCode'
                   , @iLanguageID     INT            = 1042
                   , @iType           NVARCHAR(20)   = 'MEDIUM'  -- SHORT / MEDIUM / EXTENDED
                   , @iDefalut        NVARCHAR(2000) = '' ;
                   
             SELECT dbo.D1_FN_CO_GetDictionaryTrans(@iDictionaryCode, @iLanguageID, @iType, @iDefalut)
--==============================================
-- Change History
--==============================================
-- PR   Date           Author  			 Description
-- --   ---------      -----------       ----------
-- 1    2024/02/13     Lee Jeong Won     Create
--==============================================
*/
CREATE FUNCTION dbo.D1_FN_CO_GetDictionaryTrans (
          @iDictionaryCode NVARCHAR(100)
        , @iLanguageID     INT 
        , @iType           NVARCHAR(20)
        , @iDefalut        NVARCHAR(2000)
) 
RETURNS NVARCHAR(2000)
AS 
BEGIN
    DECLARE @oResult NVARCHAR(2000) = '';
   
	-- 기본값 셋팅
    SET @iDefalut    = IIF(ISNULL(@iDefalut, '') = '', N'', @iDefalut);
   
    IF (ISNULL(@iDictionaryCode, '') = '')
    BEGIN
        RETURN @iDefalut
    END
    
    -- 기본값 셋팅
    SET @iLanguageID = IIF(ISNULL(@iLanguageID, 0) = 0, 1033, @iLanguageID);
    SET @iType       = IIF(ISNULL(@iType, '') = '', N'MEDIUM', UPPER(@iType));

    SELECT TOP 1 @oResult = 
           CASE WHEN @iType = N'SHORT'    THEN LDT.Short
                WHEN @iType = N'MEDIUM'   THEN LDT.Medium
                WHEN @iType = N'EXTENDED' THEN LDT.Extended
                ELSE @iDefalut
                END
      FROM LITERAL_DICTIONARY LD WITH(NOLOCK)
     INNER JOIN LITERAL_DICTIONARY_TRANSLATION LDT WITH(NOLOCK)
        ON LD.ID          = LDT.LiteralDictionaryID
       AND LDT.LanguageID = @iLanguageID
       AND LDT.Active     = 1
     WHERE UPPER(LD.Code) = UPPER(ISNULL(@iDictionaryCode, ''))
       AND LD.Active      = 1 ;

    RETURN ISNULL(@oResult, @iDefalut) ;
END
