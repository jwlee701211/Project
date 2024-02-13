/*
--==============================================
-- Name    : D1_FN_CO_GetTextTrans
-- Propose : Get the Text Translation
             DECLARE @iTextID     INT            = 147179
                   , @iLanguageID INT            = 1033
                   , @iType       NVARCHAR(20)   = 'MEDIUM'  -- SHORT / MEDIUM / EXTENDED
                   , @iDefalut    NVARCHAR(2000) = '' ;
                   
             SELECT dbo.D1_FN_CO_GetTextTrans(@iTextID, @iLanguageID, @iType, @iDefalut)
--==============================================
-- Change History
--==============================================
-- PR   Date           Author  			 Description
-- --   ---------      -----------       ----------
-- 1    2024/02/13     Lee Jeong Won     Create
--==============================================
*/
CREATE FUNCTION dbo.D1_FN_CO_GetTextTrans (
          @iTextID     INT
        , @iLanguageID INT 
        , @iType       NVARCHAR(20)
        , @iDefalut    NVARCHAR(2000)
) 
RETURNS NVARCHAR(2000)
AS 
BEGIN
    DECLARE @oResult NVARCHAR(2000) = '';
   
	-- 기본값 셋팅
    SET @iDefalut    = IIF(ISNULL(@iDefalut, '') = '', N'', @iDefalut);
   
    IF (ISNULL(@iTextID, 0) <= 0)
    BEGIN
        RETURN @iDefalut
    END
    
    -- 기본값 셋팅
    SET @iLanguageID = IIF(ISNULL(@iLanguageID, 0) = 0, 1033, @iLanguageID);
    SET @iType       = IIF(ISNULL(@iType, '') = '', N'MEDIUM', UPPER(@iType));

    SELECT TOP 1 @oResult = 
           CASE WHEN @iType = N'SHORT'    THEN Short
                WHEN @iType = N'MEDIUM'   THEN Medium
                WHEN @iType = N'EXTENDED' THEN Extended
                ELSE @iDefalut
                END
      FROM TEXT_TRANSLATION WITH(NOLOCK)
     WHERE TextID     = @iTextID
       AND LanguageID = @iLanguageID
       AND Active     = 1 ;

    RETURN ISNULL(@oResult, @iDefalut) ;
END
