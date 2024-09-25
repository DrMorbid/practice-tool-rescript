@react.component
let make = (
  ~onSubmit,
  ~onCancel,
  ~header,
  ~gridTemplateRows,
  ~submitPending=false,
  ~submitButtonLabel=Message.Button.save,
  ~actionButtonsRef=?,
  ~fixedHeight=?,
  ~children,
) => {
  <form onSubmit>
    <Common_PageContent
      onSecondary=onCancel
      primaryType={Submit}
      header
      gridTemplateRows
      actionPending=submitPending
      primaryButtonLabel=submitButtonLabel
      ?actionButtonsRef
      ?fixedHeight>
      children
    </Common_PageContent>
  </form>
}
