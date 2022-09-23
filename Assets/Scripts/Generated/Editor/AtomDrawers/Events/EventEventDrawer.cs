#if UNITY_2019_1_OR_NEWER
using UnityEditor;
using UnityAtoms.Editor;

namespace UnityAtoms.BaseAtoms.Editor
{
    /// <summary>
    /// Event property drawer of type `NarrativeEvents.Data.Event`. Inherits from `AtomDrawer&lt;EventEvent&gt;`. Only availble in `UNITY_2019_1_OR_NEWER`.
    /// </summary>
    [CustomPropertyDrawer(typeof(EventEvent))]
    public class EventEventDrawer : AtomDrawer<EventEvent> { }
}
#endif
