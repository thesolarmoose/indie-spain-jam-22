using System;
using Utils.Serializables;

namespace NarrativeEvents.Data.Requirements
{
    [Serializable]
    public class Always : ISerializablePredicate
    {
        public bool IsMet()
        {
            return true;
        }
    }
}